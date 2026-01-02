# Open Source version of the LED Module
# Note that this assumes we use Kernel 6.18 since that is what we compile with
final: prev:
let
  kernel = prev.linuxKernel.kernels.linux_6_18;
  git = (
    fetchGit {
      url = "https://github.com/miskcoo/ugreen_leds_controller.git";
      rev = "1defbaf27ee48842019e451e33090edc0f4ff7aa";
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
