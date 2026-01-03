# The following packages are broken by nixpkgs#471587
final: prev: {
  hidrd = (
    prev.hidrd.overrideAttrs (
      finalAttrs: prevAttrs: {
        NIX_CFLAGS = [
          "--std=gnu17"
          "-Wno-error=unterminated-string-initialization"
        ];
      }
    )
  );
}
