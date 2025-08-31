{ pkgs }:

with pkgs;
let
  shared-packages = import ../../modules/shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [

  gnumake
  cmake
  home-manager

  tree
  unixtools.ifconfig
  unixtools.netstat

]
