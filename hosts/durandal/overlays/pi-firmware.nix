final: prev: {
  raspberrypifw = prev.raspberrypifw.overrideAttrs {
    version = "1.20260523";

    src = fetchGit {
      url = "https://github.com/raspberrypi/firmware";
      rev = "c3c104bcfd90a5e6f7c89f00204ac11f1e9ffa6f";
      hash = "sha256-rpWHYPW4JotPczjB8ENzX0m+IypHX24N3GTK8s8d1dM=";
      # hash = lib.fakeHash;
    };
  };
}
