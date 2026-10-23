# Open Source version of the LED Module
# Note that this assumes we use Kernel 7.3 since that is what we compile with
final: prev:
let
  kernel = prev.linuxKernel.kernels.linux_7_3;
  git = (
    fetchGit {
      url = "https://github.com/miskcoo/ugreen_leds_controller.git";
      rev = "f0fcd8192abdd92244aba9f6f0d10572f5561380";
    }
  );
in
{
  kernelModules.ugreen_led = prev.stdenv.mkDerivation {
    pname = "ugreen_led";
    version = "v0.3";

    src = "${git}/kmod";

    hardeningDisable = [
      "pic"
      "format"
    ];
    nativeBuildInputs = kernel.moduleBuildDependencies;

    makeFlags = [
      "KERNELRELEASE=${kernel.modDirVersion}"
      "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "INSTALL_MOD_PATH=$(out)"
      # "INSTALL_MOD_DIR=extra"
      "DEPMOD=TRUE"
    ];

    # https://github.com/NixOS/nixpkgs/issues/575192
    installFlags = [
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(PWD)"
    ];

    installTargets = [ "install" ];

  };
}
