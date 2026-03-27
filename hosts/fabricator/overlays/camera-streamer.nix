final: prev: {
  camera-streamer = prev.stdenv.mkDerivation {
    pname = "camera-streamer";
    version = "v0.4.0-latest";

    src = prev.fetchFromGitHub {
      owner = "ayufan";
      repo = "camera-streamer";
      rev = "e17a86e4f9bd0fda4bd901f14a5e2eef682962f8";
      hash = "sha256-umU8Rp8+wUvQCNK8OpgND/6gPD013SB6sdXSLy5UGAQ=";
      fetchSubmodules = true;
    };

    buildInputs = [
      final.libcamera
      final.ffmpeg
      # final.liblivemedia
      final.nlohmann_json
    ];

    nativeBuildInputs = [
      final.v4l-utils
      final.pkg-config
      # final.cmake
      final.openssl
      final.xxd
    ];

    makeFlags = [
      "DEBUG=1"
      "USE_HW_H264=1"
      "USE_FFMPEG=1"
      "USE_LIBCAMERA=1"
      "USE_RTSP=0"
      "USE_LIBDATACHANNEL=0"
    ];

    env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-overflow -Wno-error=format -Wno-error=unused-result";

    installPhase = ''
      install -Dm755 camera-streamer $out/bin/camera-streamer
    '';

  };
}
