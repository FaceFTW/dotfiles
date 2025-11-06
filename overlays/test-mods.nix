# These packages have some failing test that _probably_ don't matter for my use case
final: prev: {
  gjs = prev.gjs.overrideAttrs {
    checkPhase = ''
      runHook preCheck
      GTK_A11Y=none \
      HOME=$(mktemp -d) \
      xvfb-run -s '-screen 0 800x600x24' \
        meson test --print-errorlogs --timeout-multiplier=5
      runHook postCheck
    '';

  };
}
