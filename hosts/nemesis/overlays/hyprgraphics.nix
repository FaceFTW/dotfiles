final: prev: {
  hyprgraphics = prev.hyprgraphics.overrideAttrs {
    version = "0.5.1";

    src = prev.fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprgraphics";
      rev = "04d7d9f0e5e2d33d1f26ff1d2640341866c5cc7e";
      hash = "sha256-MRD+Jr2bY11MzNDfenENhiK6pvN+nHygxdHoHbZ1HtE=";
    };
  };
}
