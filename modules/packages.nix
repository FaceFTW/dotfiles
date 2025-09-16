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
    networking = mkEnableOption "Extra Networking Things";
    nixTools = mkEnableOption "Nix Dev Tools";
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
        pkgs.ncdu
        # openssh # I don't think I need this for sshd
        pkgs.vim
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

      # Extra Networking Things
      (lists.optional packages.nixTools [
        pkgs.inetutils
        pkgs.rsync
      ])

      # Nix Dev Tools
      (lists.optional packages.nixTools [
        pkgs.nixfmt
      ])
    ];
  };
}
