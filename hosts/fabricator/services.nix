{
  config,
  pkgs,
  lib,
  ...
}:
{
  # environment.systemPackages = [
  # ];

  ############################################
  # Webcam Daemon
  ############################################
  systemd.user.services.webcamd = {
    enable = true;
    description = "Webcam Stream Daemon";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = ''
      ${pkgs.libcamera}/bin/libcamerify ${pkgs.ustreamer}/bin/ustreamer --device=/dev/video0 --allow-origin=http://localhost:* --host=0.0.0.0 --port 8080
    '';
  };

  ############################################
  # haproxy Configuration
  ############################################
  # users.groups.haproxy = { };
  # users.users.haproxy = {
  #   name = "haproxy";
  #   extraGroups = [
  #     "haproxy"
  #     "networkmanager"
  #   ];
  # };

  # services.haproxy.enable = true;
  # services.haproxy.config = ''
  #   #Basic setup from:
  #   #https://community.octoprint.org/t/setting-up-octoprint-on-a-computer-running-fedora-centos-almalinux-or-rockylinux/37137/2

  #   global
  #     maxconn 4000
  #     user haproxy
  #     group haproxy
  #     daemon
  #     log 127.0.0.1 local0 debug

  #   defaults
  #     log     global
  #     mode    http
  #     option  httplog
  #     option  dontlognull
  #     retries 3
  #     option  redispatch
  #     option  http-server-close
  #     option  forwardfor except 127.0.0.0/8
  #     timeout http-request    10s
  #     timeout queue           1m
  #     timeout connect         10s
  #     timeout client          1m
  #     timeout server          1m
  #     timeout http-keep-alive 10s
  #     timeout check           10s

  #   frontend public
  #     bind :::80 v4v6
  #     option forwardfor except 127.0.0.1
  #     use_backend webcam if { path_beg /webcam/ }
  #     default_backend octoprint

  #   backend octoprint
  #     option forwardfor
  #     server octoprint1 127.0.0.1:5000

  #   backend webcam
  #     http-request replace-path /webcam/(.*) /\1
  #     server webcam1  127.0.0.1:8080

  #   backend webcam_hls
  #     server webcam_hls_1 127.0.0.1:28126
  # '';

}
