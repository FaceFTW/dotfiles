final: prev:
with prev;
let
  babelPkg = pkgs.python313Packages.babel.overrideAttrs {
    version = "2.16.0";
    src = fetchPypi {
      pname = "babel";
      version = "2.16.0";
      hash = lib.fakeHash;
    };
  };
in
{
  octoprint = stdenv.mkDerivation {
    pname = "octoprint";
    version = "1.11.3";

    buildInputs = [
      pkgs.python313
      pkgs.python313Packages.argon2-cffi
      babelPkg
    ];
  };
}
