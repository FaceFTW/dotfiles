{
  pkgs,
  lib,
  ...
}:
# let
# inherit (lib)
#   recurseIntoAttrs
#   mkForce
#   ;
# crossPkgs = (
#   import pkgs.path {
#     localSystem.system = "x86_64-linux";
#     crossSystem.system = "aarch64-linux";
#   }
# );
# in
{
  modules.kernel = {
    version = "6.18.32";
    src = pkgs.fetchgit {
      url = "https://github.com/raspberrypi/linux";
      rev = "bb5a64adb1b761406d0e3b6570c3d2668e9198f8";
      hash = "sha256-rpWHYPW4JotPczjB8ENzX0m+IypHX24N3GTK8s8d1dM=";
      # hash = lib.fakeHash;
    };

    crossCompile = true;

    extraConfig = with lib.kernel; {

      I2C_ISCH = no;
      DMA_BCM2708 = yes; # https://github.com/raspberrypi/linux/issues/1150
      NET_VENDOR_BROADCOM = yes;
      BROADCOM_PHY = yes;
      BCM54140_PHY = yes;
      BCM7XXX_PHY = yes;
      BCM84881_PHY = yes;
      BCM87XX_PHY = yes;
      BCM_NET_PHYLIB = yes;
      BCM_NET_PHYPTP = yes;

      # I can't for the life of me figure out why this thing gets selected
      MFD_WM8994 = yes;
      MFD_ARIZONA_I2C = module;
      MFD_ARIZONA_SPI = module;
    };
  };
  # # We use the RPi LTS Kernel via nixos-hardware
  # # Cut it down to size to reduce the compile time
  # boot.kernelPackages = recurseIntoAttrs (
  #   pkgs.linuxPackagesFor (
  #     crossPkgs.buildLinux {
  #       version = "6.18.32";
  #       src = pkgs.fetchgit {
  #         url = "https://github.com/raspberrypi/linux";
  #         rev = "bb5a64adb1b761406d0e3b6570c3d2668e9198f8";
  #         hash = "sha256-rpWHYPW4JotPczjB8ENzX0m+IypHX24N3GTK8s8d1dM=";
  #         # hash = lib.fakeHash;
  #       };

  #       kernelPatches = [
  #         ############################################
  #         # Config to reduce extra module builds
  #         ############################################
  #         # These are modules that I really will likely not need
  #         {
  #           name = "98-dont-build-unused-drivers";
  #           patch = null;
  #           structuredExtraConfig = with lib.kernel; {
  #             I2C_ISCH = no;
  #             DMA_BCM2708 = yes; # https://github.com/raspberrypi/linux/issues/1150

  #             ARCH_ACTIONS = no;
  #             ARCH_AIROHA = no;
  #             ARCH_SUNXI = no;
  #             ARCH_ALPINE = no;
  #             ARCH_APPLE = no;
  #             ARCH_ARTPEC = no;
  #             ARCH_AXIADO = no;
  #             ARCH_BERLIN = no;
  #             ARCH_BITMAIN = no;
  #             ARCH_BLAIZE = no;
  #             ARCH_CIX = no;
  #             ARCH_EXYNOS = no;
  #             ARCH_K3 = no;
  #             ARCH_LG1K = no;
  #             ARCH_HISI = no;
  #             ARCH_KEEMBAY = no;
  #             ARCH_MEDIATEK = no;
  #             ARCH_MESON = no;
  #             ARCH_MICROCHIP = no;
  #             ARCH_MMP = no;
  #             ARCH_MVEBU = no;
  #             ARCH_NXP = no;
  #             ARCH_MA35 = no;
  #             ARCH_NPCM = no;
  #             ARCH_PENSANDO = no;
  #             ARCH_QCOM = no;
  #             ARCH_REALTEK = no;
  #             ARCH_RENESAS = no;
  #             ARCH_ROCKCHIP = no;
  #             ARCH_SEATTLE = no;
  #             ARCH_INTEL_SOCFPGA = no;
  #             ARCH_SOPHGO = no;
  #             ARCH_STM32 = no;
  #             ARCH_SYNQUACER = no;
  #             ARCH_TEGRA = no;
  #             ARCH_TESLA_FSD = no;
  #             ARCH_SPRD = no;
  #             ARCH_THUNDER = no;
  #             ARCH_THUNDER32 = no;
  #             ARCH_UNIPHIER = no;
  #             ARCH_VEXPRESS = no;
  #             ARCH_VISCONTI = no;
  #             ARCH_XGENE = no;
  #             ARCH_ZYNQMP = no;
  #           };
  #         }
  #       ];

  #       ignoreConfigErrors = true;
  #     }
  #   )
  # );

  # boot.kernel.buildConfig.patchSets = [
  #   { name = "rm-unused-fs"; }
  #   { name = "rm-x86-platform-drivers"; }
  #   { name = "rm-unused-driver-categories"; }
  #   { name = "rm-unused-individual-drivers"; }
  #   { name = "rm-net-top-level"; }
  #   { name = "rm-net-dsa-drivers"; }
  #   {
  #     name = "rm-net-ethernet-drivers";
  #     overrides = with lib.kernel; {
  #       NET_VENDOR_BROADCOM = yes;
  #     };
  #   }
  #   { name = "rm-net-wlan-drivers"; }
  #   {
  #     name = "rm-net-ethernet-specific-phy";
  #     overrides = with lib.kernel; {
  #       BROADCOM_PHY = yes;
  #       BCM54140_PHY = yes;
  #       BCM7XXX_PHY = yes;
  #       BCM84881_PHY = yes;
  #       BCM87XX_PHY = yes;
  #       BCM_NET_PHYLIB = yes;
  #       BCM_NET_PHYPTP = yes;
  #     };
  #   }
  #   { name = "rm-parallel-ata"; }
  #   { name = "rm-unused-graphics"; }
  #   { name = "rm-hid-specific-keyboard"; }
  #   { name = "rm-hid-specific-mouse"; }
  #   { name = "rm-hid-misc"; }
  #   { name = "rm-pcie-top-level"; }
  #   { name = "rm-scsi-top-level"; }
  #   { name = "rm-media-tuners"; }
  #   { name = "rm-dallas-1wire"; }
  #   { name = "rm-watchdog-timers"; }
  #   {
  #     name = "rm-multifunction-device";
  #     overrides = with lib.kernel; {
  #       # I can't for the life of me figure out why this thing gets selected
  #       MFD_WM8994 = yes;
  #       MFD_ARIZONA_I2C = module;
  #       MFD_ARIZONA_SPI = module;
  #     };
  #   }
  #   { name = "rm-specific-regulators"; }
  #   { name = "rm-specific-graphics-drm"; }
  #   { name = "rm-specific-backlight-lcd"; }
  #   { name = "rm-specific-battery-sensors"; }
  #   { name = "rm-specific-rtc-clocks"; }
  #   { name = "rm-specific-hw-clocks"; }
  #   { name = "rm-specific-pinctrl"; }
  #   { name = "rm-specific-serial"; }
  # ];

}
