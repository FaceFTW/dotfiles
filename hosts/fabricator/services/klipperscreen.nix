{
  pkgs,
  ...
}:
{
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
