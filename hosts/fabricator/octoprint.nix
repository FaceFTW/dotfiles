{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secret.octoprint-server-key = { };
  sops.templates."octoprint.yaml"
}
