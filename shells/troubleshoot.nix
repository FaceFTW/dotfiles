{
  pkgs,
  ...
}:
pkgs.mkShell {
  # I've had to use these programs to troubleshoot *something*,
  # so this nix shell just provides them in an easy to access location
  packages = [
    pkgs.lshw
    pkgs.v4l-utils
    pkgs.pciutils
    pkgs.efitools
    pkgs.xxd
    pkgs.patchelf
    pkgs.llvmPackages.bintoolsNoLibc
    pkgs.dtc
  ];
}
