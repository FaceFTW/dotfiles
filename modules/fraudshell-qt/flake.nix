{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      quickshell,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      nativeBuildInputs = with pkgs; [
        qt6.qtsvg
        qt6.qtimageformats
        qt6.qtmultimedia
        qt6.qt5compat
        quickshell.packages.${system}.quickshell
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
        packages = nativeBuildInputs;

        # these are useful, especially for remote dev
        DISPLAY = ":0";
        WAYLAND_DISPLAY = "wayland-1";
        DEBUG_INVOCATION = 1;
        G_MESSAGE_DEBUG = "all";

        shellHook = ''
          # export HYPRLAND_INSTANCE_SIGNATURE=$(cat HIS);
        '';
      };
    };
}
