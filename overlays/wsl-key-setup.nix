final: prev: {
  wslKeySetup = final.writeShellApplication {
    name = "wslKeySetup";
    runtimeInputs = [ final.gnupg ];
    text = ''
      #!/bin/sh

      # Check if Unix Password is set, and run setup if it hasn't been done
      if sudo cat /etc/shadow | grep 'face:!:1::::::' -q; then
        echo "Setting User Password"
        sudo passwd face
      else
        echo "User password already set"
      fi

      # Whenever I run this script, I assume I have the signing key secret
      # exported on the host in a specific location here
      if gpg --list-keys --fingerprint | grep 'CB9C CE0E 5583 06B2 1891  063A 9EB5 73C0 2E05 6DA8' -q; then
        echo "Git Signing Key Already Present"
      else
        echo "Adding Git Signing Key from Host System"
        gpg --import /mnt/c/Users/awest/gh_key.asc
        echo "CB9CCE0E558306B21891063A9EB573C02E056DA8:5" | gpg --import-ownertrust
      fi

      if test -e ~/.ssh/id_ed25519; then
        echo "SSH User key already generated"
        echo "Public Key: $(cat ~/.ssh/id_ed25519.pub)"
      else
        ssh-keygen -f ~/.ssh/id_ed25519
        echo "SSH User key created"
        echo "Public Key: $(cat ~/.ssh/id_ed25519.pub)"
        ssh-add ~/.ssh/id_ed25519
      fi
    '';
  };
}
