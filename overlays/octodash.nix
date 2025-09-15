final: prev: with prev; {
  octodash = stdenv.mkDerivation {
    pname = "octodash";
    version = "2.6.1";

    src = fetchgit {
      url = "https://github.com/UnchartedBull/OctoDash.git";
      name = "octodash";
      rev = "6d5df3f901c3cf6c813fa40ddf66054caee49845";
      hash = lib.fakeHash;
    };

    buildInputs = [
      pkgs.nodejs_24
    ];

    doCheck = false;

    buildPhase = ''
      npm install --frozen-lockfile
      npm audit fix
      npm run electron:pack
    '';

    installPhase = ''
      mkdir -p  $out/bin
      install -Dm755
    ''
  };
}
