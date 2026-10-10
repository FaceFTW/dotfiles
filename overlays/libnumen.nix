final: prev: {
  vicinae = prev.vicinae.override {
    numen = prev.numen.override {
      stdenv = final.gcc16Stdenv;
    };
    stdenv = final.gcc16Stdenv;
  };
}
