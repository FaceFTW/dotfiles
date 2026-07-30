{
  pkgs,
  lib,
  ...
}:
{
  #######################################################
  # Qt
  #######################################################
  qt.enable = true;
  qt.platformTheme = "qt5ct";
  qt.style = "kvantum";

  home-manager.users.face = {

    #######################################################
    # Kvantum
    #######################################################
    xdg.configFile."Kvantum/KvFluentDark/KvFluentDark.kvconfig".source = ./Fluent-Dark.kvconfig;
    xdg.configFile."Kvantum/KvFluentDark/KvFluentDark.svg".source = ./Fluent-round-solidDark.svg;
    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvFluentDark
    '';

    # HACK: Prevent the generated GTK-4 CSS from clobbering everything
    xdg.configFile."gtk-4.0/gtk.css".text = lib.mkForce "";

    #######################################################
    # GTK
    #######################################################
    gtk = {
      enable = true;
      colorScheme = "dark";
      theme.name = "Fluent-round-Dark-compact";
      theme.package = pkgs.fluent-gtk-theme;
      iconTheme.package = pkgs.fluent-icon-theme;
      iconTheme.name = "Fluent-dark";
      gtk4.theme.name = "Fluent-round-Dark-compact";
      gtk4.theme.package = pkgs.fluent-gtk-theme;
      gtk4.iconTheme.package = pkgs.fluent-icon-theme;
      gtk4.iconTheme.name = "Fluent-dark";
    };
  };
}
