final: prev: {
  fluent-gtk-theme = prev.fluent-gtk-theme.override {
    tweaks = [
      "solid"
      "round"
    ];

    sizeVariants = [
      "standard"
      "compact"
    ];
  };
}
