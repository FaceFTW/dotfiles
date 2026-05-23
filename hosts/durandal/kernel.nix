{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    recurseIntoAttrs
    mkForce
    ;
in
{
  # We use the RPi LTS Kernel via nixos-hardware
  # Cut it down to size to reduce the compile time
  boot.kernelPackages = recurseIntoAttrs (
    pkgs.linuxPackagesFor (
      pkgs.buildLinux {
        version = "6.18.32-rpi";
        src = pkgs.fetchgit {
          url = "https://github.com/raspberrypi/linux";
          rev = "bb5a64adb1b761406d0e3b6570c3d2668e9198f8";
          hash = "sha256-rpWHYPW4JotPczjB8ENzX0m+IypHX24N3GTK8s8d1dM=";
          # hash = lib.fakeHash;
        };

        kernelPatches = [
          ############################################
          # Config to reduce extra module builds
          ############################################
          # These are modules that I really will likely not need
          {
            name = "98-dont-build-unused-drivers";
            patch = null;
            structuredExtraConfig = with lib.kernel; {
              MEDIA_SUPPORT = no;
              WLAN = no;
              IEEE802154_DRIVERS = no;
              USB_NET_DRIVERS = no;
              SOUND = mkForce no;
              SND = mkForce no;
              SND_SOC_FSL_ASOC_CARD = no;
              DRM = mkForce no;
              AUXDISPLAY = mkForce no;
              FB = no;
              HIPPI = mkForce no;
            };
          }
        ];

        ignoreConfigErrors = true;
      }
    )
  );

  boot.kernel.buildConfig.patchSets = [
    { name = "rm-unused-fs"; }
    { name = "rm-x86-platform-drivers"; }
    { name = "rm-unused-driver-categories"; }
    { name = "rm-unused-individual-drivers"; }
    { name = "rm-net-top-level"; }
    { name = "rm-net-dsa-drivers"; }
    {
      name = "rm-net-ethernet-drivers";
      overrides = with lib.kernel; {
        NET_VENDOR_BROADCOM = yes;
      };
    }
    { name = "rm-net-wlan-drivers"; }
    {
      name = "rm-net-ethernet-specific-phy";
      overrides = with lib.kernel; {

        BROADCOM_PHY = yes;
        BCM54140_PHY = yes;
        BCM7XXX_PHY = yes;
        BCM84881_PHY = yes;
        BCM87XX_PHY = yes;
        BCM_NET_PHYLIB = yes;
        BCM_NET_PHYPTP = yes;
      };
    }
    { name = "rm-parallel-ata"; }
    { name = "rm-unused-graphics"; }
    { name = "rm-hid-specific-keyboard"; }
    { name = "rm-hid-specific-mouse"; }
    { name = "rm-hid-misc"; }
    { name = "rm-pcie-top-level"; }
    { name = "rm-scsi-top-level"; }
    { name = "rm-media-tuners"; }
    { name = "rm-dallas-1wire"; }
    { name = "rm-watchdogs-timers"; }
    {
      name = "rm-multifunction-device";
      overrides = with lib.kernel; {
        LPC_ICH = yes;
        LPC_SCH = yes;
        MFD_INTEL_LPSS_PCI = yes;
      };
    }
    { name = "rm-specific-regulators"; }
    {
      name = "rm-specific-graphics-drm";
      overrides = with lib.kernel; {
        DRM_I915 = yes;
      };
    }
    { name = "rm-specific-backlight-lcd"; }
  ];

}
