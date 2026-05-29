final: prev: {
  garage-webui = prev.garage-webui.overrideAttrs {
    src = fetchGit {
      url = "https://github.com/FaceFTW/garage-webui.git";
      rev = "39d6c6696b62b7b22ad5488d7e0b34dbb0941c5c";
      # hash = prev.lib.fakeHash;
    };
  };
}
