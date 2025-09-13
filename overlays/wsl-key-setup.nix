final: prev: with prev; {
  wslKeySetup = writeShellApplication {
    name = "wslKeySetup";
    runtimeInputs = [ gnupg ];
    text = ''
      #!/bin/sh

      # Whenever I run this script, I assume I have the signing key secret
      # exported on the host in a specific location here
      gpg --import /mnt/c/Users/awest/gh_key.asc
      echo "CB9CCE0E558306B21891063A9EB573C02E056DA8:5" | gpg --import-ownertrust
    '';
  };
}
