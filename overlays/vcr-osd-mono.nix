final: prev: {
  vcr-osd-mono-font = prev.stdenvNoCC.mkDerivation {
    pname = "vcr-osd-mono-font";
    version = "1.0";

    src = prev.lib.fileset.toSource {
      root = ./.;
      fileset = ./VCR_OSD_MONO_1.001.ttf;
    };

    nativeBuildInputs = [ prev.installFonts ];
  };
}
