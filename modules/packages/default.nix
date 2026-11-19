{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.modules.packages;
  inherit (lib) mkIf mkMerge mkEnableOption;

in
{
  imports = [
    ./btop.nix
    ./fastfetch.nix
    ./flameshot.nix
    ./fraudshell.nix
    ./git.nix
    ./hyprlock.nix
    ./ly.nix
    ./nodejs.nix
    ./rust.nix
    ./secrets.nix
    ./ssh-client.nix
    ./starship.nix
    ./steam.nix
    ./styling.nix
    ./vicinae.nix
    ./virtualization.nix
    ./zed.nix
    ./zsh.nix
  ];

  options.modules.packages = {
    direnv = mkEnableOption "Use direnv";
    ghidra = mkEnableOption "Ghidra";
    gitFull = mkEnableOption "Use gitFull with perl";
    monitoring = mkEnableOption "Extra System Monitoring Utils";
    ncdu = mkEnableOption "ncdu";
    networking = mkEnableOption "Extra Networking Things";
    nixTools = mkEnableOption "Nix Dev Tools";
    qtTools = mkEnableOption "QT Dev Tools";
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
        # pkgs.coreutils
        pkgs.uutils-coreutils-noprefix
        pkgs.uutils-findutils
        pkgs.uutils-diffutils
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

        pkgs.prune-nix-cache
      ];
    })
    ############################################
    # Nix Tools
    ############################################
    (mkIf packages.ghidra {
      environment.systemPackages = [
        (pkgs.ghidra.withExtensions (p: [
          p.findcrypt
          p.ghidra-delinker-extension
          p.ghidra-firmware-utils
          p.ghidra-golanganalyzerextension
          p.ghidraninja-ghidra-scripts
          # p.gnudisassembler
          p.kaiju
          p.lightkeeper
          p.machinelearning
          p.ret-sync
          p.sleighdevtools
          p.wasm
        ]))
      ];
    })

    (mkIf packages.qtTools {
      environment.systemPackages = [
        pkgs.qt6.qtsvg
        pkgs.qt6.qtimageformats
        pkgs.qt6.qtmultimedia
        pkgs.qt6.qt5compat
        pkgs.qt6.qtdeclarative
        pkgs.quickshell # Through overlay
      ];
    })
  ];
}
