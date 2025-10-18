final: prev: with prev; {
  final.moonraker = moonraker.overrideAttrs {
    version = "nightly-2025-10-17";
    src = fetchGit {
      url = "https://github.com/Arksine/moonraker.git";
      rev = "3eb575d0ec4408954bfa835a36ddf2cce2047bd4";
    };
  };

  # NOTE: There is quite a bit of hard-coding of paths here
  moonrakerSopsApiKey = writeShellApplication {
    name = "provisionMoonrakerKey";
    runtimeInputs = [ python3 ];
    text = ''
      # Gracefully exit if db is not found, this is for bootstrapping situations
      # where the key would need to be generated before hand
      if [ ! -f /var/lib/moonraker/database/moonraker-sql.db ]; then
          echo "No Moonraker database found, assuming first init"
          exit 0
      fi

      if [ ! -f /run/secrets/moonraker_key ]; then
        echo "No API Key secret loaded from sops-nix, assuming first init"
        exit 0
      fi

      API_KEY = $(cat /run/secrets/moonraker_key)

      APIKEY_SCRIPT=$(cat << EOF
      import sqlite3
      conn = sqlite3.connect("/var/lib/moonraker/database/moonraker-sql.db")
      with conn:
          conn.execute(
              "UPDATE authorized_users SET password = ? WHERE username='_API_KEY_USER_'",
              (sys.argv[1],)
          )
      conn.close()
      EOF
      )

      ${pkgs.python3} -c "$APIKEY_SCRIPT" $API_KEY
    '';
  };
}
