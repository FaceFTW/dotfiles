{ pkgs, lib, ... }:
{
  ############################################
  # Audio
  ############################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;

  ############################################
  # Power Management
  ############################################
  services.tuned.enable = true;
  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";

  ############################################
  # Syncthing
  ############################################
  services-custom.syncthing.enable = true;
  services-custom.syncthing.user-level = true;
  services-custom.syncthing.key = "/run/secrets/syncthing/key.pem";
  services-custom.syncthing.cert = "/run/secrets/syncthing/cert.pem";
  services-custom.syncthing.user = "face";

  # GPG Things
  # programs.gnupg.agent.enable = true;
  # programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  ############################################
  # SSH Server
  ############################################
  services-custom.ssh-server.enable = true;
  services-custom.ssh-server.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHn2LRPb2U5JR4lIKsZzXLofDvXeBinzC6a4s/+6G/5E awest@manifold"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuQw4U+Wam1gjuEXyH/cObZfnfYiA/LPF0kjQPFTz9x face@manifold-wsl"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3fuhneqp6s6Ye9hHb60QrXq8vlu5INzeKlgiPtO5Pq alex@faceftw.dev"
  ];

  ############################################
  # Keyring-related
  ############################################
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];
  services.xserver.displayManager.sessionCommands = ''
    eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
    export SSH_AUTH_SOCK
  '';

  ############################################
  # Miscellaneous
  ############################################
  # Bluetooth management
  services.blueman.enable = true;

  # GNOME-Related things that are use somewhere
  services.gvfs.enable = true;
  services.gvfs.package = lib.mkForce pkgs.gnome.gvfs;
  services.tumbler.enable = true;
  programs.dconf.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allows querying FW updates
  services.fwupd.enable = true;

  # Autostart btop monitor as a kiosk
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "${pkgs.btop}/bin/btop --config /home/face/.config/btop/btop.conf --preset 1 --force-utf --no-tty"
    ];
    serviceConfig.User = "face"; # this is unconventional
    serviceConfig.Group = "users";
  };
}
