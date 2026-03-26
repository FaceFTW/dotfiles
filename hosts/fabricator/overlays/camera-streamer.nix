final: prev: {
  camera-streamer = prev.stdenv.mkDerivation {
    pname = "camera-streamer";
    version = "v0.4.0-latest";

    src = prev.fetchFromGitHub {
      owner = "ayufan";
      repo = "camera-streamer";
      rev = "e17a86e4f9bd0fda4bd901f14a5e2eef682962f8";
      hash = prev.lib.fakeHash;
      fetchSubmodules = true;
    };

    buildInputs = [
      final.libcamera
      final.libavformat
      final.libavutil
      final.libavcodec
      final.liblivemedia-dev
    ];

    nativeBuildInputs = [
      final.v4l-utils
      final.pkg-config
    ];

  };
}
