{
  pkgs,
  lib,
  ...
}:
{

  services.navidrome = {
    enable = true;
    user = "face"; # Don't feel like dealing with ACLs
    group = "users";
    openFirewall = true;
    settings = {
      MusicFolder = "/mnt/archive/musik";
      DataFolder = "/mnt/archive/musik/navidrome";
    };
  };
}
