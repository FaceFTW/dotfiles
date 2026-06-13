{
  pkgs,
  ...
}:
{
  ############################################
  # Webcam Daemon
  ############################################
  systemd.services.webcamd = {
    enable = true;
    description = "Webcam Stream Daemon";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    path = [
      pkgs.v4l-utils
      pkgs.libcamera-rpi
    ];
    environment.LIBCAMERA_LOG_LEVEL = "0";
    environment.LIBCAMERA_IPA_MODULE_PATH = "${pkgs.libcamera-rpi}/share/libcamera/ipa";
    environment.LIBCAMERA_RPI_CONFIG_FILE = "${pkgs.libcamera-rpi}/share/libcamera/pipeline/rpi/vc4/rpi_apps.yaml";
    environment.LIBCAMERA_LOG_FILE = "/tmp/libcamera.log";

    serviceConfig.ExecStart = (
      builtins.foldl' (acc: e: acc + " " + e) "" [
        "${pkgs.libcamera-rpi}/bin/libcamerify"
        "${pkgs.ustreamer}/bin/ustreamer"
        "--device=/dev/video0"
        "--format=YUYV"
        "--slowdown"
        "--encoder=HW"
        "--resolution=1280x720"
        "--drop-same-frames=30"
        "--desired-fps=15"
        "--allow-origin=http://localhost:*"
        "--host=0.0.0.0"
        "--port=5123"
        "--verbose"
      ]
    );

    serviceConfig.User = "klipper";
    serviceConfig.Group = "klipper";
    serviceConfig.SupplementaryGroups = [
      "camera"
      "i2c"
    ];
  };
}
