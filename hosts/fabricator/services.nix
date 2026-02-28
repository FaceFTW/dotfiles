{
  pkgs,
  lib,
  ...
}:
{
  systemUser.klipper.home = "/var/lib/klipper";
  systemUser.klipper.extraGroups = [ "video" ];

  environment.systemPackages = [
    pkgs.klipperscreen
  ];

  services.klipper = {
    enable = true;
    user = "klipper";
    group = "klipper";
    firmwares.fabricator.enable = true;
    firmwares.fabricator.configFile = ./klipper/Kconfig;
    firmwares.fabricator.serial = /dev/serial/by-id/usb-Klipper_stm32g0b0xx_36004C0001504E5238363120-if00;
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
    enable = false;
    description = "Webcam Stream Daemon";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    serviceConfig.ExecStart = (
      lib.foldl' (acc: e: acc + " " + e) "" [
        "${pkgs.libcamera}/bin/libcamerify"
        "${pkgs.ustreamer}/bin/ustreamer"
        "--device=/dev/video0"
        "--format=uyvy"
        "--encoder=M2M-VIDEO"
        "--resolution=1280x720"
        "--desired-fps=15"
        "--allow-origin=http://localhost:*"
        "--host=0.0.0.0"
        "--port=5123"
        "--verbose"
      ]
    );

    serviceConfig.User = "klipper";
    serviceConfig.Group = "klipper";
    serviceConfig.SupplementaryGroups = [ "camera" ];
  };

  ############################################
  # Mainsail + Nginx Config
  ############################################
  services.nginx = {
    enable = true;
    user = "klipper";
    group = "klipper";

    httpConfig = ''
      client_max_body_size 10m;
    '';

    upstreams.mainsail-apiserver.servers."localhost:7125" = { };
    upstreams.webcam-server.servers."localhost:5123" = { };

    virtualHosts.ingress = {
      serverName = "fabricator";
      listenAddresses = [
        "0.0.0.0"
        "[::0]"
      ];
      extraConfig = "client_max_body_size 1g;";

	  root = "${pkgs.mainsail}/share/mainsail";

      locations."/".tryFiles = "$uri $uri/ /index.html";

      locations."/index.html".extraConfig =
        "add_header Cache-Control \"no-store, no-cache, must-revalidate\"";

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
