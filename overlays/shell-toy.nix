final: prev:
with prev;
let
  rustTargets = {
    x86_64-linux = "x86_64-unknown-linux-musl";
    aarch64-linux = "aarch64-unknown-linux-musl";
  };
in
{

  shell-toy = prev.pkgsStatic.rustPlatform.buildRustPackage {
    pname = "sh-toy";
    version = "0.7.2";

    srcs = [
      (lib.fileset.toSource {
        root = ./..;
        fileset = lib.fileset.union ../config/fortunes.txt ../config/cowsay;
      })
      (fetchgit {
        url = "https://github.com/FaceFTW/shell-toy.git";
        name = "sh-toy-source";
        rev = "e6a170079e675407d22012536877118a6177d69a";
        hash = "sha256-X0kogkkLden5KpOxDdoL3m/0Q9AsyeSVuOP9sekwoMY=";
        # hash = prev.lib.fakeHash;
      })
    ];

    sourceRoot = "sh-toy-source";
    cargoHash = "sha256-kLQ8ev48N2H1dbUMCGvvzq8cl5EG6x1H6rEYVeJ9aPo=";

    doCheck = false;

    FORTUNE_FILE = "../source/config/fortunes.txt";
    COW_PATH = "../source/config/cowsay";
    RUSTFLAGS = "-C target-feature=+crt-static";

    # The sed thing fixes an aarch64 compilation issue, removes things not used in my builds
    buildPhase = ''
      sed -i -e 's/"lzma"/#"lzma"/' -e 's/"xz"/#"xz"/' Cargo.toml
      cargo build --verbose --release --features inline-fortune,inline-cowsay --target ${
        rustTargets.${stdenv.hostPlatform.system}
      }
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 target/${rustTargets.${stdenv.hostPlatform.system}}/release/sh-toy $out/bin
    '';
  };
}
