# Modified significantly from the Nixpkgs SD Card Image system
# Rev: https://github.com/NixOS/nixpkgs/blob/374e6bcc403e02a35e07b650463c01a52b13a7c8/nixos/modules/installer/sd-card/sd-image-aarch64.nix
# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/sd-card/sd-image-aarch64.nix -A config.system.build.sdImage
{
  config,
  lib,
  pkgs,
  ...
}:
let
  firmwarePartitionOffset = 8;
  firmwarePartitionID = "0x2178694e";
  firmwarePartitionName = "FIRMWARE";
  firmwareSize = 30;

  rootVolumeLabel = "NIXOS_SD";
  baseName = "nixos-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";

  sdClosureInfo = pkgs.buildPackages.closureInfo { rootPaths = [ config.system.build.toplevel ]; };
  nixPathRegistrationFile = "/nix-path-registration";

  configTxt = pkgs.writeText "config.txt" ''
    camera_auto_detect=1
    display_auto_detect=1

    [pi4]
    kernel=u-boot-rpi4.bin
    enable_gic=1
    armstub=armstub8-gic.bin

    disable_overscan=1

    arm_boost=1


    [all]
    arm_64bit=1
    enable_uart=1
    avoid_warnings=1
  '';

  rootfsImage = pkgs.stdenv.mkDerivation {
    name = "ext4-fs.img.zst";
    nativeBuildInputs = [
      pkgs.e2fsprogs.bin
      pkgs.libfaketime
      pkgs.perl
      pkgs.fakeroot
      pkgs.zstd
    ];

    buildCommand = ''
      img=temp.img
      (
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
      )

      echo "Preparing store paths for image..."

      mkdir -p ./rootImage/nix/store
      xargs -I % cp -a --reflink=auto % -t ./rootImage/nix/store/ < ${sdClosureInfo}/store-paths
      (
        GLOBIGNORE=".:.."
        shopt -u dotglob

        for f in ./files/*; do
            cp -a --reflink=auto -t ./rootImage/ "$f"
        done
      )

      # Also include a manifest of the closures in a format suitable for nix-store --load-db
      cp ${sdClosureInfo}/registration ./rootImage/nix-path-registration

      # Make a crude approximation of the size of the target image.
      # If the script starts failing, increase the fudge factors here.
      numInodes=$(find ./rootImage | wc -l)
      numDataBlocks=$(du -s -c -B 4096 --apparent-size ./rootImage | tail -1 | awk '{ print int($1 * 1.20) }')
      bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
      echo "Creating an EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks)"

      # Round up to the nearest mebibyte for partition alignment (assuming 512B sectors)
      mebibyte=$(( 1024 * 1024 ))
      if (( bytes % mebibyte )); then
        bytes=$(( ( bytes / mebibyte + 1) * mebibyte ))
      fi

      truncate -s $bytes $img

      faketime -f "1970-01-01 00:00:01" fakeroot mkfs.ext4 -L ${rootVolumeLabel} -U 44444444-4444-4444-8888-888888888888 -d ./rootImage $img

      export EXT2FS_NO_MTAB_OK=yes
      # I have ended up with corrupted images sometimes, I suspect that happens when the build machine's disk gets full during the build.
      if ! fsck.ext4 -n -f $img; then
        echo "--- Fsck failed for EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks) ---"
        cat errorlog
        return 1
      fi

      # https://github.com/NixOS/nixpkgs/issues/125121
      # TL;DR: shrink to fit, then resize with 16MB extra afterward
      resize2fs -M $img
      new_size=$(dumpe2fs -h $img | awk -F: \
        '/Block count/{count=$2} /Block size/{size=$2} END{print (count*size+16*2**20)/size}')
      resize2fs $img $new_size

      echo "Compressing image"
      zstd -T$NIX_BUILD_CORES -v --no-progress ./$img -o $out
    '';
  };

in

{
  config = {
    fileSystems."/boot/firmware".device = "/dev/disk/by-label/${firmwarePartitionName}";
    fileSystems."/boot/firmware".fsType = "vfat";
    fileSystems."/boot/firmware".options = [
      "nofail"
      "noauto"
    ];

    fileSystems."/".device = "/dev/disk/by-label/${rootVolumeLabel}";
    fileSystems."/".fsType = "ext4";

    system.nixos.tags = [ "sd-card" ];
    system.build.image = pkgs.stdenv.mkDerivation {
      name = "${baseName}.img.zst";

      nativeBuildInputs = [
        pkgs.dosfstools
        pkgs.e2fsprogs
        pkgs.libfaketime
        pkgs.mtools
        pkgs.util-linux
        pkgs.zstd
      ];

      buildCommand = ''
        mkdir -p $out/nix-support $out/sd-image
        export img=$out/sd-image/${baseName}.img

        echo "${pkgs.stdenv.buildPlatform.system}" > $out/nix-support/system
        echo "file sd-image $img.zst" >> $out/nix-support/hydra-build-products

        root_fs=${rootfsImage}
        root_fs=./root-fs.img
        echo "Decompressing rootfs image"
        zstd -d --no-progress "${rootfsImage}" -o $root_fs

        # Gap in front of the first partition, in MiB
        gap=${toString firmwarePartitionOffset}

        # Create the image file sized to fit /boot/firmware and /, plus slack for the gap.
        rootSizeBlocks=$(du -B 512 --apparent-size $root_fs | awk '{ print $1 }')
        firmwareSizeBlocks=$((${toString firmwareSize} * 1024 * 1024 / 512))
        imageSize=$((rootSizeBlocks * 512 + firmwareSizeBlocks * 512 + gap * 1024 * 1024))
        truncate -s $imageSize $img

        # type=b is 'W95 FAT32', type=83 is 'Linux'.
        # The "bootable" partition is where u-boot will look file for the bootloader
        # information (dtbs, extlinux.conf file).
        sfdisk --no-reread --no-tell-kernel $img <<EOF
            label: dos
            label-id: ${firmwarePartitionID}

            start=''${gap}M, size=$firmwareSizeBlocks, type=b
            start=$((gap + ${toString firmwareSize}))M, type=83, bootable
        EOF

        # Copy the rootfs into the SD image
        eval $(partx $img -o START,SECTORS --nr 2 --pairs)
        dd conv=notrunc if=$root_fs of=$img seek=$START count=$SECTORS

        # Create a FAT32 /boot/firmware partition of suitable size into firmware_part.img
        eval $(partx $img -o START,SECTORS --nr 1 --pairs)
        truncate -s $((SECTORS * 512)) firmware_part.img

        mkfs.vfat --invariant -i ${firmwarePartitionID} -n ${firmwarePartitionName} firmware_part.img

        # Populate the files intended for /boot/firmware
        mkdir firmware
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)

        # Add the config
        cp ${configTxt} firmware/config.txt

        # Add pi3 specific files
        cp ${pkgs.ubootRaspberryPi3_64bit}/u-boot.bin firmware/u-boot-rpi3.bin
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-2-b.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-3-b.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-3-b-plus.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-cm3.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-zero-2.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-zero-2-w.dtb firmware/

        # Add pi4 specific files
        cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin firmware/u-boot-rpi4.bin
        cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-4-b.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-400.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4s.dtb firmware/

        find firmware -exec touch --date=2000-01-01 {} +
        # Copy the populated /boot/firmware into the SD image
        cd firmware
        # Force a fixed order in mcopy for better determinism, and avoid file globbing
        for d in $(find . -type d -mindepth 1 | sort); do
          faketime "2000-01-01 00:00:00" mmd -i ../firmware_part.img "::/$d"
        done
        for f in $(find . -type f | sort); do
          mcopy -pvm -i ../firmware_part.img "$f" "::/$f"
        done
        cd ..

        # Verify the FAT partition before copying it.
        fsck.vfat -vn firmware_part.img
        dd conv=notrunc if=firmware_part.img of=$img seek=$START count=$SECTORS

        zstd -T$NIX_BUILD_CORES --rm $img
      '';
    };

    boot.postBootCommands = ''
      # On the first boot do some maintenance tasks
      if [ -f ${nixPathRegistrationFile} ]; then
        set -euo pipefail
        set -x

        # Figure out device names for the boot device and root filesystem.
        rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /)
        bootDevice=$(lsblk -npo PKNAME $rootPart)
        partNum=$(lsblk -npo MAJ:MIN $rootPart | ${pkgs.gawk}/bin/awk -F: '{print $2}')

        # Resize the root partition and the filesystem to fit the disk
        echo ",+," | sfdisk -N$partNum --no-reread $bootDevice
        ${pkgs.parted}/bin/partprobe
        ${pkgs.e2fsprogs}/bin/resize2fs $rootPart

        # Register the contents of the initial Nix store
        ${config.nix.package.out}/bin/nix-store --load-db < ${nixPathRegistrationFile}

        # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

        # Prevents this from running on later boots.
        rm -f ${nixPathRegistrationFile}
      fi
    '';

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;
    boot.consoleLogLevel = lib.mkDefault 7;
    boot.kernelParams = [ "console=tty0" ];

  };

}
