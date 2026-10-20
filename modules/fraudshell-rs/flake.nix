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
      astalPackages = lib.mapAttrsToList (_: val: val) astal.packages.${system};

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

      gir-files = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "fraudshell-link-girs";
        version = "0.1.0";

        src = pkgs.fetchFromGitHub {
          owner = "gtk-rs";
          repo = "gir-files";
          rev = "3449225041844513256468b84d74ff5fe8bf60ca";
          hash = "sha256-o54GFkkoWnfG6GGvZhYUD1AQJPUifAHz9zGpzhTJsQw=";
        };

        buildInputs = astalPackages;

        installPhase = let
          astalDevOuts = map (x: x.dev) (lib.filter (x: lib.hasAttr "dev" x) astalPackages);
          astalPaths = map (x: "${x}/share/gir-1.0/*.gir") astalDevOuts;
          copyCmds = lib.concatMapStringsSep "\n" (x: "install -Dm555 ${x} -t $out/share/gir-1.0") astalPaths;
        in ''
          mkdir -p $out/share/gir-1.0
          install -Dm555 -t $out/share/gir-1.0 $src/*.gir
          ${copyCmds}
        '';
      };

      nativeBuildInputs = with pkgs; [
        meson
        ninja
        pkg-config
        gobject-introspection
        freetype
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

        # these are useful, especially for remote dev
        DISPLAY = ":0";
        WAYLAND_DISPLAY = "wayland-1";
        DEBUG_INVOCATION = 1;
        G_MESSAGE_DEBUG = "all";

        GTK_GIR_PATH = gir-files;

        shellHook =
          let
            astalDevOuts = map (x: x.dev) (lib.filter (x: lib.hasAttr "dev" x) astalPackages);
            astalPaths = map (x: "${x}/share/gir-1.0/*.gir") astalDevOuts;
            copyCmds = lib.concatMapStringsSep "\n" (x: "cp -f ${x} astal-bindings/girs") astalPaths;
          in
          ''
            # export HYPRLAND_INSTANCE_SIGNATURE=$(cat HIS);

            function update-astal-girs() {
              ${copyCmds}
              sudo chown face:users astal-bindings/girs/*.gir
              chmod +w astal-bindings/girs/*.gir

              # TODO Add postprocessing (remove xmlns:ns2 attr)
            }

            function generate-gir-binds() {
              gir -d $GTK_GIR_PATH \
                  -d ../girs \
                  -o .
            }
          '';

      };
    };
}
