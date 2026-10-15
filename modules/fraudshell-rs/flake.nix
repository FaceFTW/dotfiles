{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust Toolchain
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      astal,
      fenix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      rust-toolchain = fenix.packages.${system}.latest.toolchain;
      rustPlatform = pkgs.makeRustPlatform {
        cargo = rust-toolchain;
        rustc = rust-toolchain;

      };

      gir-rs = rustPlatform.buildRustPackage {
        pname = "gir-rs";
        version = "0.19.0";

        src = nixpkgs.legacyPackages.${system}.fetchgit {
          url = "https://github.com/gtk-rs/gir.git";
          rev = "ececdfdf7154dc77d5d3e2a9aa19690b47161641";
          hash = "sha256-YaRnhPQHBx7dnzXGeapX1IkcnKRY++UiuyqbJot7u2A=";
          leaveDotGit = true; # used in build.rs
        };

        cargoHash = "sha256-YaYqmFoKIaF0ZFuvAIHDR4hokYTjyuQ+fI5zyWYUs0c=";

        nativeBuildInputs = [ pkgs.git ];

        patchPhase = ''
          runHook prePatch

          sed -i '15s%.*%%' build.rs

          runHook postPatch
        '';
      };

      nativeBuildInputs = with pkgs; [
        meson
        ninja
        pkg-config
        gobject-introspection
        wrapGAppsHook4
        blueprint-compiler
        dart-sass
        vala
        json-glib
        gtk4-layer-shell
        networkmanager
        libnma-gtk4
        upower
        rust-toolchain
        gir-rs
      ];

      astalPackages = lib.mapAttrsToList (_: val: val) astal.packages.${system};
    in
    {
      # packages.${system}.default = pkgs.stdenv.mkDerivation {
      #   name = "fraudshell";
      #   src = ./.;
      #   inherit nativeBuildInputs;
      #   buildInputs = astalPackages;
      # };

      # overlays.default = final: prev: {
      #   fraudshell = self.packages.${system}.default;
      # };

      devShells.${system}.default = pkgs.mkShell {
        packages = nativeBuildInputs ++ astalPackages;

        DISPLAY = ":0";
        WAYLAND_DISPLAY = "wayland-1";
        DEBUG_INVOCATION = 1;
        G_MESSAGE_DEBUG = "all";

        # shellHook = ''
        #   export HYPRLAND_INSTANCE_SIGNATURE=$(cat HIS);
        # '';
      };
    };
}
