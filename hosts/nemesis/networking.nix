{ ... }:
{
  networking.hostName = "nemesis";
  networking.networkmanager.enable = true;

  services.resolved.enable = true;
}
