final: prev: {
  fastfetch = prev.fastfetch.override {
    audioSupport = false;
    brightnessSupport = false;
    codecSupport = false;
    dbusSupport = false;
    enlightenmentSupport = false;
    gnomeSupport = false;
    openclSupport = false;
    openglSupport = false;
    rpmSupport = false;
    sqliteSupport = false;
    vulkanSupport = false;
    waylandSupport = false;
    x11Support = false;
    xfceSupport = false;
    zfsSupport = false;
  };
}
