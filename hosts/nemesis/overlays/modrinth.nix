final: prev: {
  # modrinth-app = prev.modrinth-app.overrideAttrs {
  #   postBuild = ''
  #     gappsWrapperArgs+=(
  #       --prefix PATH : ${
  #         prev.lib.makeSearchPath "bin/java" [
  #           prev.jdk8
  #           prev.jdk17
  #           prev.jdk21
  #           prev.jdk25
  #         ]
  #       }
  #       ${prev.lib.optionalString prev.stdenv.hostPlatform.isLinux ''
  #         --prefix PATH : ${prev.lib.makeBinPath [ prev.xrandr ]}
  #         --set LD_LIBRARY_PATH $runtimeDependencies
  #       ''}
  #     )

  #     glibPostInstallHook
  #     gappsWrapperArgsHook
  #     wrapGApp "$out/bin/ModrinthApp"
  #   '';
  # };

  modrinth-app-unwrapped = prev.modrinth-app-unwrapped.overrideAttrs rec {
    version = "0.17.3";

    src = prev.fetchFromGitHub {
      owner = "modrinth";
      repo = "code";
      tag = "v0.17.3";
      hash = "sha256-9PpUh02d0av3mPvDbNSIJeVqN5pG/8K6WHa/pT0Jems=";
    };

    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "modrinth-app-unwrapped-v0.17.3";
      hash = "sha256-grrFXOZtno6Z7deTYn8DcOkQ9y2LEOvKi8+cezh0RXQ=";
    };

    pnpmDeps = prev.fetchPnpmDeps {
      inherit version src;
      pname = "modrinth-app-unwrapped";
      pnpm = prev.pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-mMoNSvA0GZ7lUfXY3Yqpi3CWifTfwGDQJKG6dJbAhOc=";
    };
  };
}
