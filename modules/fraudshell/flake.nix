{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal = {
      url = "github:FaceFTW/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      astal,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      nativeBuildInputs = with pkgs; [

        # TODO Remove once meson 1.12 hits unstable
        (meson.overrideAttrs rec {
          version = "1.12.0";
          src = fetchFromGitHub {
            owner = "mesonbuild";
            repo = "meson";
            tag = version;
            hash = "sha256-3Zeavn6aW6920gM7yE73Ms1RPCP2GjX9IUL9YGmISfY=";
          };
        })
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
      ];

      astalPackages = with astal.packages.${system}; [
        astal4
        apps
        auth
        battery
        bluetooth
        brightness
        greet
        hyprland
        io
        network
        notifd
        powerprofiles
        tray
        wireplumber
      ];
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "fraudshell";
        src = ./.;
        inherit nativeBuildInputs;
        buildInputs = astalPackages;
      };

      overlays.default = final: prev: {
        fraudshell = self.packages.${system}.default;
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = nativeBuildInputs ++ astalPackages;

        DISPLAY = ":0";
        WAYLAND_DISPLAY = "wayland-1";
        DEBUG_INVOCATION = 1;
        G_MESSAGE_DEBUG = "all";

        shellHook = ''
          export HYPRLAND_INSTANCE_SIGNATURE=$(cat HIS);
        '';
      };
    };
}
