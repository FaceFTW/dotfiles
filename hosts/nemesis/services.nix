{ ... }:
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

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.dconf.enable = true;

}
