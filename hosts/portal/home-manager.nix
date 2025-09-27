{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = "face";
  xdg_configHome = "/home/${user}/.config";
  shared-programs = (import ../../modules/home.nix { inherit config pkgs lib; });
in
{
  ############################################
  # Common Home-Manager Config
  ############################################
  home.enableNixpkgsReleaseCheck = false;
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.packages = pkgs.callPackage ./user-packages.nix { };
  home.stateVersion = "25.05";
  xdg.enable = true;

  # For disabling the GPG Agent autostart
  home.file.".gnupg/common.conf".enable = true;
  home.file.".gnupg/common.conf".text = "no-autostart";

  programs = shared-programs;
}
