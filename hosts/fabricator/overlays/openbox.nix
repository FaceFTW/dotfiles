# Allow setting custom autostart script for openbox
# https://blog.stigok.com/2020/06/20/nixos-xserver-openbox-auto-start-browser-application.html
self: super: {
  openbox = super.openbox.overrideAttrs (oldAttrs: {
    postFixup = ''
      ln -sf /etc/openbox/autostart $out/etc/xdg/openbox/autostart
    '';
  });
}
