# Using Raspberry Pi fork of libcamera
final: prev: {
  libcamera = (
    prev.libcamera.overrideAttrs {
      src = prev.fetchgit {
        url = "https://github.com/raspberrypi/libcamera.git";
        rev = "bfd68f786964636b09f8122e6c09c230367390e7";
        hash = "sha256-4rNV9TMDvVpMBmgeRftO51ptOyHh4QOgoyZ6F/Iwdnw=";
      };
    }
  );
}
