{
  pkgs,
  lib,
  ...
}:
{
  systemUser.klipper.home = "/var/lib/klipper";
  systemUser.klipper.extraGroups = [ "camera" ];

  environment.systemPackages = [
    pkgs.klipperscreen
  ];

  services.klipper = {
    enable = true;
    user = "klipper";
    group = "klipper";
    firmwares.fabricator.enable = true;
    firmwares.fabricator.enableKlipperFlash = true;
    firmwares.fabricator.configFile = ./klipper/Kconfig;
    firmwares.fabricator.serial = "/dev/serial/by-id/usb-Klipper_stm32g0b0xx_36004C0001504E5238363120-if00";
    configFile = ./klipper/printer.cfg;
  };

  ############################################
  # Moonraker Config
  ############################################
  environment.etc."moonraker.cfg".source = ./klipper/moonraker.cfg;

  systemd.tmpfiles.rules = [
    "d '/var/lib/moonraker' - klipper klipper - -"
    "d '/var/lib/moonraker/tools/klipper_estimator' - klipper klipper - -"
    "L+ '/var/lib/moonraker/tools/klipper_estimator/klipper_estimator_linux' - - - - ${lib.getExe pkgs.klipper-estimator}"
  ];

  systemd.services.moonraker = {
    description = "Moonraker, an API web server for Klipper";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "klipper.service"
      "moonraker-key-setup.service"
    ];

    # Moonraker really wants its own config to be writable...
    script = ''
      config_path="/var/lib/moonraker/config/moonraker-temp.cfg"
      mkdir -p $(dirname "$config_path")
      cp /etc/moonraker.cfg "$config_path"
      chmod u+w "$config_path"
      exec ${pkgs.moonraker}/bin/moonraker -d /var/lib/moonraker -c "$config_path"
    '';

    # Needs `ip` command
    path = [ pkgs.iproute2 ];

    serviceConfig.WorkingDirectory = /var/lib/moonraker;
    serviceConfig.PrivateTmp = true;
    serviceConfig.Group = "klipper";
    serviceConfig.User = "klipper";
  };

  systemd.services.moonraker-key-setup = {
    description = "Initializes pre-generated Moonraker API Key";
    wantedBy = [ "multi-user.target" ];
    before = [ "moonraker.service" ];
    path = [ pkgs.moonrakerSopsApiKey ];

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.moonrakerSopsApiKey}/bin/provisionMoonrakerKey";
  };

  ############################################
  # Webcam Daemon
  ############################################
  systemd.services.webcamd = {
    enable = true;
    description = "Webcam Stream Daemon";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    unitConfig.ConditionPathExists = "/sys/bus/i2c/drivers/imx708/10-001a/video4linux";

    serviceConfig.ExecStart = (
      lib.foldl' (acc: e: acc + " " + e) "" [
        "${pkgs.camera-streamer}/bin/camera-streamer"
        "--camera-path=/base/soc/i2c0mux/i2c@1/imx708@1a"
        "--camera-path=/dev/video0"
        "--camera-type=v4l2"
        "--camera-format=YUYV"
        "--camera-width=4608"
        "--camera-height=2592"
        "--camera-fps=15"
        "--camera-nbufs=2"
        "--camera-snapshot.height=1080"
        "--camera-video.height=720"
        "--camera-stream.height=480"
        "--camera-options=AfMode=2"
        "--camera-options=AfRange=2"
        "--http-listen=0.0.0.0"
        "--http-port=5123"
      ]
    );

    serviceConfig.User = "klipper";
    serviceConfig.Group = "klipper";
    serviceConfig.SupplementaryGroups = [
      "camera"
      "i2c"
    ];
  };

  ############################################
  # Mainsail + Nginx Config
  ############################################
  services.nginx = {
    enable = true;
    user = "klipper";
    group = "klipper";

    upstreams.mainsail-apiserver.servers."127.0.0.1:7125" = { };
    upstreams.webcam-server.servers."127.0.0.1:5123" = { };

    virtualHosts.ingress = {
      serverName = "fabricator";
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
        {
          addr = "[::0]";
          port = 80;
        }
      ];
      extraConfig = ''
        index index.html;
        client_max_body_size 1g;
      '';

      root = "${pkgs.mainsail}/share/mainsail";

      locations."/".tryFiles = "$uri $uri/ /index.html";

      locations."/index.html".extraConfig =
        "add_header Cache-Control \"no-store, no-cache, must-revalidate\";";

      locations."/websocket".proxyPass = "http://mainsail-apiserver/websocket";
      locations."/websocket".recommendedProxySettings = true;
      locations."/websocket".proxyWebsockets = true;

      locations."~ ^/(webcam)".proxyPass = "http://webcam-server$request_uri";
      locations."~ ^/(webcam)".recommendedProxySettings = true;
      locations."~ ^/(webcam)".proxyWebsockets = true;

      locations."~ ^/(printer|api|access|machine|server)/".proxyPass =
        "http://mainsail-apiserver$request_uri";
      locations."~ ^/(printer|api|access|machine|server)/".recommendedProxySettings = true;
      locations."~ ^/(printer|api|access|machine|server)/".proxyWebsockets = true;
    };
  };

  ############################################
  # KlipperScreen
  ############################################
  services.libinput.enable = true;

  services.cage.enable = true;
  services.cage.program = pkgs.writeShellScript "cage-program" ''
    cd /home/face
    "${pkgs.klipperscreen}/bin/KlipperScreen"
  '';
  services.cage.extraArguments = [ "-d" ];
  services.cage.user = "face";
}
