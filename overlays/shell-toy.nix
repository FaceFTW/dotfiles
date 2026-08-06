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
    version = "0.8.1";

    srcs = [
      (lib.fileset.toSource {
        root = ./..;
        fileset = lib.fileset.union ../config/fortunes.txt ../config/cowsay;
      })
      (fetchgit {
        url = "https://github.com/FaceFTW/shell-toy.git";
        name = "sh-toy-source";
        rev = "98859fa49ca1cc0061edd5d1a47607290eb3b7f3";
        hash = "sha256-K7ctG61fEqshjLVmSv7oBIwclE1W51TLjqPL8KZODUA=";
        # hash = prev.lib.fakeHash;
      })
    ];

    sourceRoot = "sh-toy-source";
    cargoHash = "sha256-TI3PCy9VqqsCCmpUznIlIAY8Ic0CZe1IlucycMzhyCQ=";

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
