{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
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
  ];
}
