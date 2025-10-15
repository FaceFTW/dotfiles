{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.klipper.enable = true;
  services.klipper.firmwares.fabricator.enable = true;
  services.klipper.firmwares.fabricator.configFile = ./klipper/Kconfig;
  services.klipper.firmwares.fabricator.serial =
    /dev/serial/by-id/usb-Klipper_stm32g0b0xx_36004C0001504E5238363120-if00;
  services.klipper.configFile = ./klipper/printer.cfg;

  ############################################
  # Moonraker Config
  ############################################
  environment.etc."moonraker.cfg".source = ''
    [analysis]
    enable_estimator_updates:false
    platform:linux

    [authorization]
    cors_domains:
      *://*.local
      *://*.lan
    trustedClients:
      10.0.0.0/8
      127.0.0.0/8
      172.16.0.0/12
      192.168.0.0/16
      FE80::/10
      ::1/128

    [file_manager]
    check_klipper_config_path:false

    [machine]
    provider:none
    validate_service:false

    [server]
    host:127.0.0.1
    klippy_uds_address:/run/klipper/api
    port:7125

  '';

  systemd.tmpfiles.rules = [
    "d '/var/lib/moonraker' - klipper klipper - -"
    "d '/var/lib/moonraker/tools/klipper_estimator' - klipper klipper - -"
    "L+ '/var/lib/moonraker/tools/klipper_estimator/klipper_estimator_linux' - - - - ${lib.getExe pkgs.klipper-estimator}"
  ];

  systemd.services.moonraker = {
    description = "Moonraker, an API web server for Klipper";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ] ++ lib.optional config.services.klipper.enable "klipper.service";

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

  ############################################
  # Mainsail + Nginx Config
  ############################################
  services.nginx = {
    enable = true;
    upstreams.mainsail-apiserver.servers."127.0.0.1:7125" = { };
    virtualHosts."fabricator" = {
      root = lib.mkForce "${pkgs.mainsail}/share/mainsail";
      locations = {
        "/" = {
          index = "index.html";
          tryFiles = "$uri $uri/ /index.html";
        };
        "/index.html".extraConfig = ''
          add_header Cache-Control "no-store, no-cache, must-revalidate";
        '';
        "/websocket" = {
          proxyWebsockets = true;
          proxyPass = "http://mainsail-apiserver/websocket";
        };
        "~ ^/(printer|api|access|machine|server)/" = {
          proxyWebsockets = true;
          proxyPass = "http://mainsail-apiserver$request_uri";
        };
      };
    };
  };

  # services.moonraker.enable = true;
  # services.moonraker.group = "klipper";
  # services.moonraker.user = "klipper";
  # services.moonraker.analysis.enable = true;
  # services.moonraker.settings.authorization.trustedClients = [
  #   "10.0.0.0/8"
  #   "127.0.0.0/8"
  #   "172.16.0.0/12"
  #   "192.168.0.0/16"
  #   "FE80::/10"
  #   "::1/128"
  # ];
  # services.moonraker.settings.authorization.cors_domains = [
  #   "*://*.local"
  #   "*://*.lan"
  # ];

  # services.mainsail.enable = true;
}
