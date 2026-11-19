{
  config,
  lib,
  pkgs,
  ...
}:
let
  replaceByPairs =
    with lib;
    xs: str:
    let
      keys = map (x: elemAt x 0) xs;
      vals = map (x: elemAt x 1) xs;
    in
    replaceStrings keys vals str;

  hyprlandConfig = config.modules.packages.hyprland;
in
{
  options.modules.packages.hyprland = {
    enable = lib.mkEnableOption "Hyprland (System + User Config)";

    configPath = lib.mkOption {
      description = "Path to the hyprland.lua configuration";
      type = lib.types.path;
    };

    configSubstitutions = lib.mkOption {
      description = ''
        List of string pairs which describe how to replace placeholder
        values in the hyprland.lua config. This is primarily useful for
        adding references to executables in the Nix store instead of relying
        on their presence in some FHS environment.

        The first pair defines the string to look for in hyprland.lua, the second
        string is the value that should be rendered in the final configuration.
        This will apply to all matches found in the hyprland.lua provided.
      '';
      type = with lib.types; listOf (listOf str);
    };

    filePicker = lib.mkOption {
      description = ''
        Which XDG-Compatible File Picker application to use.
      '';
      type = with lib.types; package;
    };

    plugins = lib.mkOption {
      description = "Hyprland Plugins to install";
      type = with lib.types; listOf package;
      default = [ ];
    };

  };

  config = lib.mkIf hyprlandConfig.enable {
    programs.hyprland.enable = true;
    programs.hyprland.package = pkgs.hyprland;
    programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

    xdg.portal.extraPortals = [ hyprlandConfig.filePicker ];

    systemd.user.services.hyprpolkitagent = {
      serviceConfig.ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
    };

    home-manager.users.face.wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      plugins = hyprlandConfig.plugins;
      systemd.enable = false;
      configType = "lua";
    };

    home-manager.users.face.home.file.".config/hypr/hyprland.lua".text =
      with lib;
      replaceByPairs hyprlandConfig.configSubstitutions (
        lib.unsafeDiscardStringContext (readFile hyprlandConfig.configPath)
      );

    home-manager.users.face.home.activation = {
      hyprland-meta-link = config.home-manager.users.face.lib.dag.entryAfter [ "writeBoundary" ] ''
        run ln -sf $VERBOSE_ARG ${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua /home/face/.local/hl.meta.lua
      '';
    };
  };

}
