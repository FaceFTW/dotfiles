{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  reverseProxySpec =
    with types;
    submodule {
      options.localPort = mkOption {
        type = port;
        description = "The local port for the service that Nginx should proxy to";
      };

      options.serverName = mkOption {
        type = str;
        description = "What URL should Nginx use when determining where to proxy the request";
      };

      options.additionalServerNames = mkOption {
        type = listOf str;
        description = "Additional domains this target should get proxy traffic";
        default = [ ];
      };

      options.extraConfig = mkOption {
        type = str;
        description = "Extra vHost configuration to apply";
        default = "";
      };
    };

  mkUpstream =
    name:
    {
      localPort,
      ...
    }:
    {

      servers."localhost:${lib.toString localPort}" = { };
    };

  mkVHost =
    name:
    {
      localPort,
      serverName,
      additionalServerNames,
      extraConfig,
      ...
    }:
    {
      inherit extraConfig;

      serverName = "${serverName} ${lib.concatStringsSep " " additionalServerNames}";

      forceSSL = true;
      useACMEHost = "faceftw.dev";

      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
      ];

      locations."/".proxyPass = "http://${name}";
      locations."/".recommendedProxySettings = true;
      locations."/".proxyWebsockets = true;
    };
in
{

  options.modules.nginx.reverse-proxy = mkOption {
    type = with types; attrsOf reverseProxySpec;
    description = "Reverse Proxy template";
  };

  config = {
    services.nginx.upstreams = lib.mapAttrs' (name: rProxyDef: {
      inherit name;
      value = (mkUpstream name rProxyDef);
    }) config.modules.nginx.reverse-proxy;

    services.nginx.virtualHosts = lib.mapAttrs' (name: rProxyDef: {
      name = rProxyDef.serverName;
      value = (mkVHost name rProxyDef);
    }) config.modules.nginx.reverse-proxy;
  };

}
