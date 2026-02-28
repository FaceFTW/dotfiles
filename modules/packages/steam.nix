{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );
  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
  inherit (lib) mkIf mkMerge mkEnableOption;
in
{
  options.packages.steam = mkEnableOption "Valve Steam";
  options.packages.steam-nvidia-prime = mkEnableOption "Patch Steam + Desktop Files to use nvidia-offload";

  config = mkMerge [
    ############################################
    # Valve Steam
    ############################################
    (mkIf packages.steam {
      programs.steam.enable = true;
      programs.steam.remotePlay.openFirewall = true;
      programs.steam.localNetworkGameTransfers.openFirewall = true;

      programs.steam.protontricks.enable = true;

      programs.steam.package = pkgs.steam.override {
        extraPkgs = pkgs: [
          pkgs.primus
          pkgs.bumblebee
          pkgs.mesa-demos
          pkgs.gamemode
        ];
      };
    })
    ############################################
    # Patching Steam/Games for NVIDIA Optimus
    ############################################
    (mkIf packages.steam-nvidia-prime {
      environment.systemPackages = [
        (GPUOffloadApp pkgs.steam "steam")
      ];

      users.users.face.packages = [
        (pkgs.writeShellScriptBin "patch-steam-desktop-entries" ''
          #!/bin/bash
          cd ~/.local/share/applications
          IFS=
          for file in $(${pkgs.coreutils}/bin/grep -l steam://rungameid *.desktop); do
            ${pkgs.gnused}/bin/sed 's#^Exec=#Exec=nvidia-offload #g' < "$file" > "$file"
          done
        '')
      ];

      # Monitor this path to ensure that .desktop files calling steam also do nvidia prime thing
      # This is because steam-generated shortcuts are not really manageable in nix-store

      # systemd.user.paths."fix-steam-desktop-entries" = {
      #   pathConfig.PathChanged = "%h/.local/share/applications";
      #   # pathConfig.Unit = "fix-steam-desktop-entries";
      #   wantedBy = [ "default.target" ];
      # };

      # systemd.user.services.fix-steam-desktop-entries = {
      #   script = ''
      #     cd ~/.local/share/applications
      #     IFS=
      #     for file in $(${pkgs.coreutils}/bin/grep -l steam://rungameid *.desktop); do
      #       ${pkgs.gnused}/bin/sed 's#^Exec=#Exec=nvidia-offload #g' < "$file" > "$file"
      #     done
      #   '';
      # };

    })
  ];
}
