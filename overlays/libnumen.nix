final: prev: {
  vicinae = prev.vicinae.override {
    numen = (prev.numen.overrideAttrs {
      version = "0.7.0";
      src = prev.fetchFromGitHub {
        owner = "vicinaehq";
        repo = "numen";
        tag = "v0.7.0";
        hash = "sha256-+mz4dMdNgEx/GfGophP2B1WCrWonBrFFM1cF+pEz2h8=";
      };
    }).override {
      stdenv = final.gcc15Stdenv;
    };
  };
}
