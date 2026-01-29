{ pkgs, ... }:
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
  services.tumbler.enable = true;

  # Gnome
  programs.dconf.enable = true;

  # Syncthing
  service.syncthing.enable = true;
  service.syncthing.key = "/run/secrets/syncthing/key.pem";
  service.syncthing.cert = "/run/secrets/syncthing/cert.pem";
  service.syncthing.accessibleFolders = [ "/mnt/citadel/Workspaces" ];
  service.syncthing.folderOwner = "face";

  # GPG Things
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-qt;

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

}
