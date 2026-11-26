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
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./ly.nix
    ./nodejs.nix
    ./nix-tools.nix
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
    direnv.enable = mkEnableOption "Use direnv";
    ghidra.enable = mkEnableOption "Ghidra";
    monitoring.enable = mkEnableOption "Extra System Monitoring Utils";
    monitoring.ncdu.enable = mkEnableOption "ncdu";
    networking.enable = mkEnableOption "Extra Networking Things";
    qtTools.enable = mkEnableOption "QT Dev Tools";
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
    (mkIf packages.direnv.enable {
      programs.direnv.enable = true;
      programs.direnv.enableZshIntegration = true;
      programs.direnv.nix-direnv.enable = true;
      programs.direnv.silent = false;
    })

    ############################################
    # Ghidra
    ############################################
    (mkIf packages.ghidra.enable {
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

    ############################################
    # Monitoring Tools
    ############################################
    (mkIf packages.monitoring.enable {
      environment.systemPackages = [
        pkgs.htop
        pkgs.iftop
        pkgs.iotop
      ];
    })
    # Separated because Zig compilation on aarch64 weird
    (mkIf packages.monitoring.ncdu.enable {
      environment.systemPackages = [
        pkgs.ncdu
      ];
    })

    ############################################
    # Networking Tools
    ############################################
    (mkIf packages.networking.enable {
      environment.systemPackages = [
        pkgs.inetutils
        pkgs.rsync
      ];
    })

    ############################################
    # Qt Tools
    ############################################
    (mkIf packages.qtTools.enable {
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
