{
  pkgs,
  ...
}:
pkgs.mkShell {
  packages = [
    pkgs.qt6.qtsvg
    pkgs.qt6.qtimageformats
    pkgs.qt6.qtmultimedia
    pkgs.qt6.qt5compat
    pkgs.qt6.qtdeclarative
    pkgs.quickshell # Through overlay
  ];

  DISPLAY = ":0";
  WAYLAND_DISPLAY = "wayland-1";
  DEBUG_INVOCATION = 1;
  G_MESSAGE_DEBUG = "all";

}
