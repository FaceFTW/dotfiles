{
  ...
}:
{
  ############################################
  # Syncthing
  ############################################
  modules.services.syncthing.enable = true;
  modules.services.syncthing.key = "/run/secrets/syncthing/key.pem";
  modules.services.syncthing.cert = "/run/secrets/syncthing/cert.pem";
  modules.services.syncthing.accessibleFolders = [ "/mnt/motorway/Workspaces" ];
  modules.services.syncthing.folderOwner = "face";

  # Nginx Reverse Proxy Config
  services.nginx.upstreams.syncthing-gui.servers."localhost:8384" = { };
  services.nginx.virtualHosts."syncthing.archiver.faceftw.local" = {
    serverName = "archiver";
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
    ];

    extraConfig = ''
      proxy_set_header Host localhost; # https://docs.syncthing.net/users/faq.html#why-do-i-get-host-check-error-in-the-gui-api
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Server $hostname;
    '';
    locations."/".proxyPass = "http://syncthing-gui";
  };

}
