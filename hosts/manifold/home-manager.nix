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
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { };
    # file = shared-files // import ./files.nix { inherit user; };
    file = import ./files.nix { inherit user; };
    stateVersion = "25.05";
  };

  programs = shared-programs // {
    gpg.enable = true;
  };

}
