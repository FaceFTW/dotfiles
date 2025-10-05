{ config, pkgs, lib, ... }:
let
  packages = config.packages;
  inherit (lib)
    mkIf
    mkEnableOption
    lists
    ;
in
{
  imports = [
    ./packages/nodejs.nix
    ./packages/rust.nix
    ./packages/virtualization.nix
  ];

  options.packages = {
    gitFull = mkEnableOption "Use gitFull with perl";
    secretsMan = mkEnableOption "Install Secrets Management Things";
    monitoring = mkEnableOption "Extra System Monitoring Utils";
    ncdu = mkEnableOption "ncdu";
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
      ]

      # Git (Big or smol?)
      (lists.optional packages.gitFull [
        pkgs.gitFull
      ])
      (lists.optional (!packages.gitFull) [
        pkgs.git
      ])

      # GnuPG
      (lists.optional packages.secretsMan [
        pkgs.gnupg
        pkgs.sops
        pkgs.ssh-to-age
        pkgs.socat
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
        pkgs.nix-index
        pkgs.nil
      ])

    ];

  };
}
