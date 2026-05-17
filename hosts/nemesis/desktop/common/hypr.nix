{
  pkgs,
  ...
}:
{
  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.hyprland;
  programs.hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;

  systemd.user.services.hyprpolkitagent = {
    serviceConfig.ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
  };

  environment.sessionVariables.AQ_DRM_DEVICES = "/dev/dri/intel_gpu:/dev/dri/nvidia_gpu";

  #######################################################
  # Hyprland
  #######################################################
  home-manager.users.face.wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    plugins = [
      # pkgs.hyprlandPlugins.hyprbars
      # pkgs.hyprlandPlugins.csgo-vulkan-fix
    ];
    systemd.enable = false;

    # Config is set per theme
    configType = "lua";
  };

  #######################################################
  # LOCK SCREEN
  #######################################################
  home-manager.users.face.programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;

    settings.general = {
      no_fade_in = true;
      no_fade_out = true;
      hide_cursor = false;
      grace = 0;
      disable_loading_bar = true;
    };

    settings.input-field = {
      monitor = "";
      size = "250, 60";
      outline_thickness = 2;
      dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true;
      fade_on_empty = false;
      rounding = -1;
      hide_input = false;
      position = "0, -200";
      halign = "center";
      valign = "center";
    };

    settings.image = {
      monitor = "";
      path = "${./face.png}";
      size = 100;
      border_size = 2;
      border_color = "rgba(242,243,244,0.75)";
      position = "0, -100";
      halign = "center";
      valign = "center";
    };
  };
}
