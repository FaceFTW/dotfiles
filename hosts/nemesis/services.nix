{ pkgs, lib, ... }:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;

  services.fwupd.enable = true;

  services.tuned.enable = true;
  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";

  # Bluetooth management
  services.blueman.enable = true;

  # Ad-hoc disk mounting
  services.gvfs.enable = true;
  services.gvfs.package = lib.mkForce pkgs.gnome.gvfs;
  services.tumbler.enable = true;

  # Gnome
  programs.dconf.enable = true;

  # Syncthing
  service.syncthing.enable = true;
  service.syncthing.user-level = true;
  service.syncthing.key = "/run/secrets/syncthing/key.pem";
  service.syncthing.cert = "/run/secrets/syncthing/cert.pem";
  service.syncthing.user = "face";

  # GPG Things
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  # Keyring
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];
  services.xserver.displayManager.sessionCommands=''
    eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
    export SSH_AUTH_SOCK
  '';

  xdg.portal.extraPortals = [ pkgs.microsoft-identity-broker ];

}
