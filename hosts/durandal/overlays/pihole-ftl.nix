final: prev: {
  pihole-ftl = prev.pihole-ftl.overrideAttrs {
    NIX_CFLAGS_COMPILE="-Wno-unused-but-set-variable";
  };
}
