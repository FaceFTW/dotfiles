final: prev: {
  numen = prev.numen.override {
    stdenv = final.gcc15Stdenv;
  };

  vicinae = prev.vicinae.override {
    numen = final.numen;
    stdenv = final.gcc15Stdenv;
  };
}
