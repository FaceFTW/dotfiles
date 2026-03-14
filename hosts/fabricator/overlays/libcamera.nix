# Using Raspberry Pi fork of libcamera
final: prev: {
  libcamera = (
    prev.libcamera.overrideAttrs {
      src = prev.fetchgit {
        url = "https://github.com/raspberrypi/libcamera.git";
        rev = "fe601eb6ffe02922ff980c60621dd79d401d9061";
        hash = "sha256-pFvdy1sEGIVlIfIbBRdnNz7pVR4u5bMAL8UCtmUIVVs=";
      };
    }
  );
}
