final: prev: {
  flashrom = prev.flashrom.overrideAttrs {
    doCheck = false;
    doInstallCheck = false;
  };
}
