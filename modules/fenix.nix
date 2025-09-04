{
  config,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [ pkgs.fenix.overlays.default ];

  environment.systemPackages = with pkgs; [
    (fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rustdoc"
    ])
    (fenix.nightly.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
  ];
}
