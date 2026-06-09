final: prev: {
  klipperscreen = prev.klipperscreen.overrideAttrs {
    pythonPath = with prev.python3.pkgs; [
      jinja2
      netifaces
      requests
      websocket-client
      pycairo
      pygobject3
      (mpv.overrideAttrs {
        doCheck = false;
        doInstallCheck = false;
      })
      six
      dbus-python
      sdbus-networkmanager
    ];
  };
}
