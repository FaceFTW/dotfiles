{
  ...
}:
{
  # These specializations explicitly include the fix to
  # the D3Cold Bug here
  # https://github.com/linux-surface/linux-surface/wiki/Surface-Laptop-Studio#nvidia-gpu-locked-at-10w-power-limit
  #
  # I don't want to enable it all the time, 10W should be
  # sufficient for most things and even some games
  specialisation.prime-offload.configuration = {
    hardware.nvidia.prime.offload.enable = true;
    hardware.nvidia.prime.offload.enableOffloadCmd = true;

    boot.extraModprobeConfig = ''
      options nvidia "NVreg_DynamicPowerManagement=0x00"
    '';
  };

  specialisation.prime-sync.configuration = {
    hardware.nvidia.prime.sync.enable = true;

    boot.extraModprobeConfig = ''
      options nvidia "NVreg_DynamicPowerManagement=0x00"
    '';
  };

}
