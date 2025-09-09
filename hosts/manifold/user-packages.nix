{ pkgs }:
with pkgs;
let
  shared-packages = import ../../modules/shared/user-packages.nix { inherit pkgs; };
in
shared-packages
++ [
  gnumake
  cmake
]
