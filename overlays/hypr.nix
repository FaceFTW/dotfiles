final: prev: {
  hyprland = prev.hyprland.overrideAttrs (
    final: prev: {
      patches = [ ./hyprland-glaze.patch ];
    }
  );
  xdg-desktop-portal-hyprland = prev.xdg-desktop-portal-hyprland.overrideAttrs (
    final: prev: {
      patches = [ ./hyprland-glaze.patch ];
    }
  );
}
