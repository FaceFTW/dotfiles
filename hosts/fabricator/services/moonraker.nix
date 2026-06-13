{
  pkgs,
  lib,
  ...
}:
{
  ############################################
  # Moonraker Config
  ############################################
  environment.etc."moonraker.cfg".text = ''
    [analysis]
    enable_estimator_updates:false
    platform:linux

    [authorization]
    cors_domains:
        *://*.local
        *://*.lan
        *://127.0.0.1
        # *://192.168.0.198

    trusted_clients:
        127.0.0.0/8
        192.168.0.0/24
        # If I ever change networks, use this
        # 10.0.0.0/8
        # FE80::/10
        # ::1/128

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

}
