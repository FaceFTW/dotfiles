# Bringing in the nixos-hardware version of the Microsoft
# Surface kernel because otherwise I can't apply additional
# config patches that I want
{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    recurseIntoAttrs
    ;

  # Fetch the latest linux-surface patches
  linux-surface = pkgs.fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "321be2e7ebbb751153a97c6ed38836f2f4300dc6";
    hash = "sha256-ZclXmq4hjGjLofulPsind6il2wBQmeQl3TGvRxfsMp0=";
    # hash = lib.fakeHash;
  };

  betterLinuxPackage = pkgs.buildLinux {
    version = "7.0";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v7.x/linux-7.0.tar.xz";
      hash = "sha256-u39tgLOHx1e30Uu5MCj8uQ95PFwNNnc27oFaEAs4kfA=";
      # hash = lib.fakeHash;
    };

    kernelPatches = import ./kernel-patches.nix {
      inherit lib;
      version = "7.0";
      patchSrc = linux-surface + "/patches/6.18";
    };

    ignoreConfigErrors = true;
  };

in
{
  boot.kernelPackages = recurseIntoAttrs (pkgs.linuxPackagesFor betterLinuxPackage);
}
