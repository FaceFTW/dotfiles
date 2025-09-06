{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rust-docs"
    ])
    (fenix.complete.withComponents [
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pkgs.rust-analyzer-nightly
    pkgs.pkg-config
    pkgs.openssl
  ];
}
