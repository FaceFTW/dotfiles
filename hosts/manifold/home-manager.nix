{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "face";
  xdg_configHome = "/home/${user}/.config";
  shared-programs = import ../../modules/shared/home-manager.nix { inherit config pkgs lib; };
  # shared-files = import ../../modules/shared/files.nix { inherit config pkgs; };
in
{
  ############################################
  # Common Home-Manager Config
  ############################################
  home.enableNixpkgsReleaseCheck = false;
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.packages = pkgs.callPackage ./user-packages.nix { };
  # file = import ./files.nix { inherit user; };
  home.stateVersion = "25.05";

  programs = shared-programs;

}
