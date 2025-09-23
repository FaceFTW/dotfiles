{ config, pkgs, ... }:
let
  packages = config.packages;
  inherit (pkgs.lib)
    mkIf
    mkEnableOption
    lists
    ;
in
{
  imports = [ ];

  options.packages = {
    gitFull = mkEnableOption "Use gitFull with perl";
    gnupg = mkEnableOption "Install GnuPG";
    monitoring = mkEnableOption "Extra System Monitoring Utils";
    ncdu = mkEnableOption "ncdu";
    networking = mkEnableOption "Extra Networking Things";
    nixTools = mkEnableOption "Nix Dev Tools";
    armVirt = mkEnableOption "QEMU + ARM Virtualization";
  };

  config = {
    environment.systemPackages = lists.flatten [
      # Core Utilities
      [
        pkgs.shell-toy

        pkgs.bash-completion
        pkgs.bat
        pkgs.coreutils
        pkgs.curl
        pkgs.htop
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
        pkgs.unixtools.sysctl
        pkgs.unixtools.top
        pkgs.unixtools.umount

        pkgs.fzf # Used with Vim config

        pkgs.rbw
        pkgs.pinentry-curses
      ]

      # Git (Big or smol?)
      (lists.optional packages.gitFull [
        pkgs.gitFull
      ])
      (lists.optional (!packages.gitFull) [
        pkgs.git
      ])

      # GnuPG
      (lists.optional packages.gnupg [
        pkgs.gnupg
      ])

      # Extra Monitoring Tools
      (lists.optional packages.nixTools [
        pkgs.htop
        pkgs.iftop
        pkgs.iotop
      ])

      # Extra Monitoring Tools
      (lists.optional packages.ncdu [
        pkgs.ncdu
      ])

      # Extra Networking Things
      (lists.optional packages.nixTools [
        pkgs.inetutils
        pkgs.rsync
      ])

      # Nix Dev Tools
      (lists.optional packages.nixTools [
        pkgs.nixfmt
        pkgs.nix-tree
        pkgs.nix-output-monitor
        pkgs.nix-index
      ])

      # ARM Virtualization - Used for building RasPi images
      (lists.optional packages.armVirt [
        pkgs.qemu
      ])
    ];

    boot.binfmt.emulatedSystems = mkIf packages.armVirt [ "aarch64-linux" ]; # For Cross-Compiling Raspberry Pi Things
  };
}
