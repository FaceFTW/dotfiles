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

      ];

      astalPackages = with astal.packages.${system}; [
        astal4
        apps
        auth
        battery
        bluetooth
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

      devShells.${system}.default = pkgs.mkShell {
        packages = nativeBuildInputs ++ astalPackages;
      };
    };
}
