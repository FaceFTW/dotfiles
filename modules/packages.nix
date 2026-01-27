{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
  # patchDesktop =
  #   pkg: appName: from: to:
  #   lib.hiPrio (
  #     pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
  #       ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
  #       ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
  #     ''
  #   );
  # GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
  inherit (lib) mkIf mkMerge mkEnableOption;

in
{
  imports = [
    ./packages/gnu.nix
    ./packages/nodejs.nix
    ./packages/rust.nix
    ./packages/secrets.nix
    ./packages/virtualization.nix
  ];

  options.packages = {
    direnv = mkEnableOption "Use direnv";
    gitFull = mkEnableOption "Use gitFull with perl";
    monitoring = mkEnableOption "Extra System Monitoring Utils";
    ncdu = mkEnableOption "ncdu";
    networking = mkEnableOption "Extra Networking Things";
    nixTools = mkEnableOption "Nix Dev Tools";
    steam = mkEnableOption "Valve Steam";
    steam-nvidia-prime = mkEnableOption "Patch Steam + Desktop Files to use nvidia-offload";
  };

  config = mkMerge [
    ############################################
    # Common Packages
    ############################################
    {
      environment.systemPackages = [
        pkgs.shell-toy

        pkgs.bash-completion
        pkgs.bat
        pkgs.coreutils
        pkgs.curl
        # openssh # I don't think I need this for sshd
        pkgs.vimCustom # See overlays/vim.nix for config
        pkgs.zip

        pkgs.unixtools.fsck
        pkgs.unixtools.hexdump
        pkgs.unixtools.ifconfig
        pkgs.unixtools.mount
        pkgs.unixtools.netstat
        pkgs.unixtools.ping
        pkgs.unixtools.ps
        pkgs.unixtools.top
        pkgs.unixtools.umount

        pkgs.fzf # Used with Vim config
      ];
    }

    ############################################
    # direnv
    ############################################
    (mkIf packages.direnv {
      programs.direnv.enable = true;
      programs.direnv.enableZshIntegration = true;
      programs.direnv.nix-direnv.enable = true;
      programs.direnv.silent = false;
    })

    ############################################
    # Git (Big or smol?)
    ############################################
    (mkIf packages.gitFull {
      environment.systemPackages = [
        pkgs.gitFull
      ];
    })
    (mkIf (!packages.gitFull) {
      environment.systemPackages = [
        pkgs.git
      ];
    })

    ############################################
    # Monitoring Tools
    ############################################
    (mkIf packages.monitoring {
      environment.systemPackages = [
        pkgs.htop
        pkgs.iftop
        pkgs.iotop
      ];
    })
    # Separated because Zig compilation on aarch64 weird
    (mkIf packages.ncdu {
      environment.systemPackages = [
        pkgs.ncdu
      ];
    })

    ############################################
    # Networking Tools
    ############################################
    (mkIf packages.networking {
      environment.systemPackages = [
        pkgs.inetutils
        pkgs.rsync
      ];
    })

    ############################################
    # Nix Tools
    ############################################
    (mkIf packages.nixTools {
      environment.systemPackages = [
        pkgs.nixfmt
        pkgs.nix-tree
        pkgs.nix-index
        pkgs.nil
      ];
    })

    ############################################
    # Valve Steam
    ############################################
    (mkIf packages.steam {
      programs.steam.enable = true;
      programs.steam.remotePlay.openFirewall = true;
      programs.steam.localNetworkGameTransfers.openFirewall = true;

      programs.steam.protontricks.enable = true;
    })
    (mkIf packages.steam-nvidia-prime {
      programs.steam.package = pkgs.steam.overrideAttrs (
        final: prev: {
          postInstall = ''
            rm $out/bin/steamdeps

            # install udev rules
            mkdir -p $out/etc/udev/rules.d/
            cp ./subprojects/steam-devices/*.rules $out/etc/udev/rules.d/
            substituteInPlace $out/etc/udev/rules.d/60-steam-input.rules \
              --replace-fail "/bin/sh" "${pkgs.bash}/bin/bash"

            # this just installs a link, "steam.desktop -> /lib/steam/steam.desktop"
            rm $out/share/applications/steam.desktop
            substitute steam.desktop $out/share/applications/steam.desktop \
              --replace-fail /usr/bin/steam steam \
              --replace-fail "Exec=" "Exec=${pkgs.nvidia-offload}/bin/nvidia-offload "
          '';
        }
      );

      # Monitor this path to ensure that .desktop files calling steam also do nvidia prime thing
      # This is because steam-generated shortcuts are not really manageable in nix-store

      # systemd.user.paths."home-local-share-applications" = {
      #   pathConfig.PathChanged = "/home/face/.local/share/applications";
      #   pathConfig.Unit = "fix-steam-desktop-entries";
      # };

      # systemd.user.services.fix-steam-desktop-entries = {
      #   script=''
      #     readarray files <(${pkgs.coreutils}/bin/grep -l steam://rungameid *.desktop)
      #     for file in "''${files[@]}"; do
      #       if [[ $(grep) ]]
      #     done
      #   '';
      # };

    })
  ];
}
