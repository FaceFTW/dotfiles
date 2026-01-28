{
  config,
  pkgs,
  lib,
  ...
}:
let
  packages = config.packages;
  # patchDesktop =
  #   pkg: appName: from: to:
  #   lib.hiPrio (
  #     pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
  #       ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
  #       ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
  #     ''
  #   );
  # GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
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
    })
    ############################################
    # Patching Steam/Games for NVIDIA Optimus
    ############################################
    (mkIf packages.steam-nvidia-prime {
      programs.steam.package = pkgs.steam.overrideAttrs (
        final: prev: {
          postInstall = ''
            rm $out/bin/steamdeps

            # install udev rules
            mkdir -p $out/etc/udev/rules.d/
            cp ./subprojects/steam-devices/*.rules $out/etc/udev/rules.d/
            substituteInPlace $out/etc/udev/rules.d/60-steam-input.rules \
              --replace-fail "/bin/sh" "${pkgs.bash}/bin/bash"

            # this just installs a link, "steam.desktop -> /lib/steam/steam.desktop"
            rm $out/share/applications/steam.desktop
            substitute steam.desktop $out/share/applications/steam.desktop \
              --replace-fail /usr/bin/steam steam \
              --replace-fail "Exec=" "Exec=${pkgs.nvidia-offload}/bin/nvidia-offload "
          '';
        }
      );

      # Monitor this path to ensure that .desktop files calling steam also do nvidia prime thing
      # This is because steam-generated shortcuts are not really manageable in nix-store

      # systemd.user.paths."home-local-share-applications" = {
      #   pathConfig.PathChanged = "/home/face/.local/share/applications";
      #   pathConfig.Unit = "fix-steam-desktop-entries";
      # };

      # systemd.user.services.fix-steam-desktop-entries = {
      #   script=''
      #     readarray files <(${pkgs.coreutils}/bin/grep -l steam://rungameid *.desktop)
      #     for file in "''${files[@]}"; do
      #       if [[ $(grep) ]]
      #     done
      #   '';
      # };
    })
  ];
}
