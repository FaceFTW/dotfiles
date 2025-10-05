{
  config,
  pkgs,
  lib,
  ...
}:
{
  ############################################
  # Common Home-Manager Config
  ############################################
  home.enableNixpkgsReleaseCheck = false;
  home.username = "face";
  home.homeDirectory = "/home/face";
  xdg.enable = true;

  programs = (import ../../modules/home.nix { inherit config pkgs lib; });

  home.stateVersion = "25.05";
}
