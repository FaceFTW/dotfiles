final: prev: with prev; {
  shell-toy = prev.pkgsStatic.rustPlatform.buildRustPackage {
    pname = "sh-toy";
    version = "0.7.3";

    srcs = [
      (lib.fileset.toSource {
        root = ./..;
        fileset = lib.fileset.union ../dotfiles/fortunes.txt ../dotfiles/cowsay;
      })
      (fetchgit {
        url = "https://github.com/FaceFTW/shell-toy.git";
        name = "sh-toy-source";
        rev = "de0185b8999f0c6188195d06c35c4c7123e7cdd3";
        hash = "sha256-m1xLo7iF10zzONa+fD6iuK50gs5oML8mtlqlt0m+KPI=";
      })
    ];

    sourceRoot = "sh-toy-source";
    cargoHash = "sha256-szG3K6nA5lOyezJfGNhP6UYsGKjZohNFdGF0JKY/JN8=";

    doCheck = false;

    FORTUNE_FILE = "../source/dotfiles/fortunes.txt";
    COW_PATH = "../source/dotfiles/cowsay";
    RUSTFLAGS = "-C target-feature=+crt-static";

    # The sed thing fixes an aarch64 compilation issue, removes things not used in my builds
    buildPhase = ''
      sed -i -e 's/"lzma"/#"lzma"/' -e 's/"xz"/#"xz"/' Cargo.toml
      cargo build --verbose --release --features inline-fortune,inline-cowsay --target x86_64-unknown-linux-musl
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 target/x86_64-unknown-linux-musl/release/sh-toy $out/bin
    '';
  };
}
