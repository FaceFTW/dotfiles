final: prev: {
  #   final.hyprland = prev.hyprland.overrideAttrs {
  #     patches = [ ./hyprland-glaze-version.patch ];
  #   };

  #   glaze =
  #     (prev.glaze.override {
  #       enableSSL = false;
  #       enableInterop = false;
  #     }).overrideAttrs
  #       {
  #         version = "6.1.0";
  #         src = prev.fetchFromGitHub {
  #           owner = "stephenberry";
  #           repo = "glaze";
  #           tag = "v6.1.0";
  #           hash = "sha256-bYXXQmrVnrBTW/r+fgRBPYfKGPtHvEDw0Sk6BYTMm/4=";
  #         };
  #       };
}
