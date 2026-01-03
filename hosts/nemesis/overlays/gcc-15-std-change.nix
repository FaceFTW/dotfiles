# The following packages are broken by nixpkgs#471587
final: prev: {
  hidrd = prev.hidrd.override {
    CFLAGS = [
      "--std=gnu17"
    ];
  };
}
