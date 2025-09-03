{ pkgs }:

with pkgs;
let
  shared-packages = import ../../modules/shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [

  gnumake
  cmake

  tree
  unixtools.ifconfig
  unixtools.netstat

]
