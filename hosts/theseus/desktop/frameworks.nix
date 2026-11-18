{
  pkgs,
  ...
}:
{
  #######################################################
  # Qt
  #######################################################
  qt.enable = true;
  qt.style = "kvantum";
  # qt.platformTheme = "qt6ct";
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

  home-manager.users.face = {

    #######################################################
    # Kvantum
    #######################################################
    xdg.configFile."Kvantum/KvFluentDark/KvFluentDark.kvconfig".source = ../assets/Fluent-Dark.kvconfig;
    xdg.configFile."Kvantum/KvFluentDark/KvFluentDark.svg".source =
      ../assets/Fluent-round-solidDark.svg;
    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvFluentDark
    '';

    #######################################################
    # GTK
    #######################################################
    gtk = {
      enable = true;
      colorScheme = "dark";
      iconTheme.package = pkgs.fluent-icon-theme;
      iconTheme.name = "Fluent-dark";
      gtk4.iconTheme.package = pkgs.fluent-icon-theme;
      gtk4.iconTheme.name = "Fluent-dark";
    };
  };
}
