final: prev: {
  numen = prev.numen.overrideAttrs (
    finalAttrs: _: {
      version = "0.7.0";

      src = prev.fetchFromGitHub {
        owner = "vicinaehq";
        repo = "numen";
        tag = "v${finalAttrs.version}";
        hash = prev.lib.fakeHash;
      };
    }
  );
}
