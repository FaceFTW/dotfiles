# Using Raspberry Pi fork of libcamera
final: prev: {
  libcamera = (
    prev.libcamera.overrideAttrs {
      src = prev.fetchgit {
        url = "https://github.com/raspberrypi/libcamera.git";
        rev = "f0e40f1c50bd0afe65727d6e407d0dcb42666ada";
        hash = "sha256-sJKzmeeXD/66P5o+X9w3J2gwxDNsdBUdXEqU6goJdN4=";
      };
    }
  );
}
