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
    version = "0.7.1";

    srcs = [
      (lib.fileset.toSource {
        root = ./..;
        fileset = lib.fileset.union ../dotfiles/fortunes.txt ../dotfiles/cowsay;
      })
      (fetchgit {
        url = "https://github.com/FaceFTW/shell-toy.git";
        name = "sh-toy-source";
        rev = "6e831e51e9f427ba61f12b0b45a07e48a74c6f67";
        hash = "sha256-fJaWAPeQZk7YqrKjvMSglvL7UVg2dDnXF+Ya2OvU82Q=";
      })
    ];

    sourceRoot = "sh-toy-source";
    cargoHash = "sha256-bW8j+sEaT54WKfTUzzTsyMIEcFtyAammbvbHdbKe2ZY=";

    doCheck = false;

    FORTUNE_FILE = "../source/dotfiles/fortunes.txt";
    COW_PATH = "../source/dotfiles/cowsay";
    RUSTFLAGS = "-C target-feature=+crt-static";

    # The sed thing fixes an aarch64 compilation issue, removes things not used in my builds
    buildPhase = ''
      sed -i -e 's/"lzma"/#"lzma"/' -e 's/"xz"/#"xz"/' Cargo.toml
      cargo build --verbose --release --features inline-fortune,inline-cowsay --target ${rustTargets.${system}}
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 target/${rustTargets.${system}}/release/sh-toy $out/bin
    '';
  };
}
