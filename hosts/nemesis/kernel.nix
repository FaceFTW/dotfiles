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
    version = "6.18.18";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-6.18.18.tar.xz";
      hash = "sha256-9IVfOCwbc1yEByve8221vNXceww35C9RBDFxSaCkhu8=";
      # hash = lib.fakeHash;
    };

    kernelPatches = import ./kernel-patches.nix {
      inherit lib;
      version = "6.18.18";
      patchSrc = linux-surface + "/patches/6.18";
    };

    ignoreConfigErrors = true;
  };

in
{
  boot.kernelPackages = recurseIntoAttrs (pkgs.linuxPackagesFor betterLinuxPackage);
}
