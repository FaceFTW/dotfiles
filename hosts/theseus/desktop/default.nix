{
  ...
}:
{
  imports = [
    ./dunst.nix
    ./flameshot.nix
    ./frameworks.nix
    ./hypr.nix
    ./silentsddm.nix
    ./vicinae.nix
  ];

  #######################################################
  # Limine
  #######################################################
  boot.loader.limine.style.wallpapers = [
    ./wallpapers/fraud-1-wallpaper.png
    ./wallpapers/fraud-2-wallpaper.png
    ./wallpapers/fraud-3-wallpaper.png
  ];
  boot.loader.limine.style.interface.branding = "ENTERING LAYER 8 - FRAUD";
}
