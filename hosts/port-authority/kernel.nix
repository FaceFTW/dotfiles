{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    recurseIntoAttrs
    mkForce
    ;
  crossPkgs = (
    import pkgs.path {
      localSystem.system = "x86_64-linux";
      crossSystem.system = "aarch64-linux";
    }
  );
in
{
  # We use the RPi LTS Kernel via nixos-hardware
  # Cut it down to size to reduce the compile time
  boot.kernelPackages = recurseIntoAttrs (
    pkgs.linuxPackagesFor (
      crossPkgs.buildLinux {
        version = "6.18.32";
        src = pkgs.fetchgit {
          url = "https://github.com/raspberrypi/linux";
          rev = "bb5a64adb1b761406d0e3b6570c3d2668e9198f8";
          hash = "sha256-rpWHYPW4JotPczjB8ENzX0m+IypHX24N3GTK8s8d1dM=";
          # hash = lib.fakeHash;
        };

        defconfig = ./rpi-zero-2-defconfig;

        kernelPatches = [
          pkgs.kernelPatches.bridge_stp_helper
          pkgs.kernelPatches.request_key_helper
          ############################################
          # Config to reduce extra module builds
          ############################################
          {
            name = "98-dont-build-unused-drivers";
            patch = null;
            structuredExtraConfig = with lib.kernel; {
              I2C_ISCH = no;
              DMA_BCM2708 = yes; # https://github.com/raspberrypi/linux/issues/1150

              ARCH_ACTIONS = no;
              ARCH_AIROHA = no;
              ARCH_SUNXI = no;
              ARCH_ALPINE = no;
              ARCH_APPLE = no;
              ARCH_ARTPEC = no;
              ARCH_AXIADO = no;
              ARCH_BERLIN = no;
              ARCH_BITMAIN = no;
              ARCH_BLAIZE = no;
              ARCH_CIX = no;
              ARCH_EXYNOS = no;
              ARCH_K3 = no;
              ARCH_LG1K = no;
              ARCH_HISI = no;
              ARCH_KEEMBAY = no;
              ARCH_MEDIATEK = no;
              ARCH_MESON = no;
              ARCH_MICROCHIP = no;
              ARCH_MMP = no;
              ARCH_MVEBU = no;
              ARCH_NXP = no;
              ARCH_MA35 = no;
              ARCH_NPCM = no;
              ARCH_PENSANDO = no;
              ARCH_QCOM = no;
              ARCH_REALTEK = no;
              ARCH_RENESAS = no;
              ARCH_ROCKCHIP = no;
              ARCH_SEATTLE = no;
              ARCH_INTEL_SOCFPGA = no;
              ARCH_SOPHGO = no;
              ARCH_STM32 = no;
              ARCH_SYNQUACER = no;
              ARCH_TEGRA = no;
              ARCH_TESLA_FSD = no;
              ARCH_SPRD = no;
              ARCH_THUNDER = no;
              ARCH_THUNDER32 = no;
              ARCH_UNIPHIER = no;
              ARCH_VEXPRESS = no;
              ARCH_VISCONTI = no;
              ARCH_XGENE = no;
              ARCH_ZYNQMP = no;
            };
          }
        ];
        ignoreConfigErrors = true;

        # TODO: Put CONFIG_LOCALVERSION in `structuredExtraConfig` above once this is resolved:
        # https://github.com/NixOS/nixpkgs/issues/516936
        postConfigure = ''
          sed -i $buildRoot/.config -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
          sed -i $buildRoot/include/config/auto.conf -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
        '';

        # The vendor kernel uses different DTB names (bcm2708/bcm2709/bcm2710) than what
        # U-Boot expects (bcm2835/bcm2836/bcm2837). Starting with Pi 4, names match.
        # See: https://github.com/u-boot/u-boot/blob/master/board/raspberrypi/rpi/rpi.c
        postFixup = ''
          	dtbDir="$out/dtbs/broadcom"
            rm $dtbDir/bcm283*.dtb
            copyDTB() {
              cp -v "$dtbDir/$1" "$dtbDir/$2"
            }

            copyDTB bcm2710-rpi-zero-2.dtb bcm2837-rpi-zero-2.dtb
            copyDTB bcm2710-rpi-zero-2-w.dtb bcm2837-rpi-zero-2-w.dtb
            copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
            copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-a-plus.dtb
            copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
            copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
        '';

      }
    )
  );

  boot.kernel.buildConfig.patchSets = [
    { name = "rm-unused-fs"; }
    { name = "rm-x86-platform-drivers"; }
    { name = "rm-unused-driver-categories"; }
    { name = "rm-unused-individual-drivers"; }
    {
      name = "rm-net-top-level";
      overrides = with lib.kernel; {
        USB_NET_DRIVERS = yes;
      };
    }
    { name = "rm-net-dsa-drivers"; }
    {
      name = "rm-net-ethernet-drivers";
      overrides = with lib.kernel; {
        NET_VENDOR_BROADCOM = yes;
      };
    }
    { name = "rm-net-wlan-drivers"; }
    {
      name = "rm-net-ethernet-specific-phy";
      overrides = with lib.kernel; {
        BROADCOM_PHY = yes;
        BCM54140_PHY = yes;
        BCM7XXX_PHY = yes;
        BCM84881_PHY = yes;
        BCM87XX_PHY = yes;
        BCM_NET_PHYLIB = yes;
        BCM_NET_PHYPTP = yes;
      };
    }
    { name = "rm-parallel-ata"; }
    { name = "rm-unused-graphics"; }
    { name = "rm-hid-specific-keyboard"; }
    { name = "rm-hid-specific-mouse"; }
    { name = "rm-hid-misc"; }
    { name = "rm-pcie-top-level"; }
    { name = "rm-scsi-top-level"; }
    { name = "rm-media-tuners"; }
    { name = "rm-dallas-1wire"; }
    { name = "rm-watchdog-timers"; }
    {
      name = "rm-multifunction-device";
      overrides = with lib.kernel; {
        # I can't for the life of me figure out why this thing gets selected
        MFD_WM8994 = yes;
        MFD_ARIZONA_I2C = module;
        MFD_ARIZONA_SPI = module;
      };
    }
    { name = "rm-specific-regulators"; }
    { name = "rm-specific-graphics-drm"; }
    { name = "rm-specific-backlight-lcd"; }
    { name = "rm-specific-battery-sensors"; }
    { name = "rm-specific-rtc-clocks"; }
    { name = "rm-specific-hw-clocks"; }
    {
      name = "rm-specific-pinctrl";
      overrides = with lib.kernel; {
        PINCTRL_BCM2712 = yes;
      };
    }
    { name = "rm-specific-serial"; }
  ];

}
