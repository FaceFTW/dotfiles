{ ... }:
{
  imports = [
    ./backrest.nix
    ./bind.nix
    ./mirror-job.nix
    ./nginx.nix
    ./ssh.nix
    ./syncthing.nix
  ];
}
