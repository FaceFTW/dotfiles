# Using Raspberry Pi fork of libcamera
final: prev: {
  libcamera-rpi = (
    prev.libcamera.overrideAttrs {
      src = prev.fetchgit {
        url = "https://github.com/raspberrypi/libcamera.git";
        rev = "6c1dd9d55573010f710c9e190a73e7e76f0d9432";
        hash = "sha256-r3ste6OwCrNvgD0oAQ+XaoWYPNVJihFW1moPDueNtnM=";
      };
    }
  );
}
