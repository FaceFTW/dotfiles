final: prev: {
  raspberrypifw = prev.raspberrypifw.overrideAttrs {
    version = "1.20261004";

    src = fetchGit {
      url = "https://github.com/raspberrypi/firmware";
      rev = "dcca4969e53d2a25e688f0f228a09486786d54c0";
      hash = "sha256-rpWHYPW4JotPczjB8ENzX0m+IypHX24N3GTK8s8d1dM=";
      # hash = lib.fakeHash;
    };
  };
}
