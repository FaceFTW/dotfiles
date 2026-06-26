# Open Source version of the LED Module
# Note that this assumes we use Kernel 7.1 since that is what we compile with
final: prev:
let
  kernel = prev.linuxKernel.kernels.linux_7_1;
  git = (
    fetchGit {
      url = "https://github.com/miskcoo/ugreen_leds_controller.git";
      rev = "d6c3b3d7c74a68851e6cf71433aa9a7c313cda22";
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
    ];
  };
}
