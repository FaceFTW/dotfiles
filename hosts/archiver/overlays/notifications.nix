final: prev: {
  mdadm-notif-event = prev.writeShellApplication {
    name = "mdadm-notif-event";
    runtimeInputs = [
      prev.curl
      prev.coreutils
    ];
    text = ''
      event_type=$1
      affected_device=$2
      related_device=''${3:-"N/A"}

      message="''${event_type} on ''${affected_device}. Related Devices: ''${related_device}"
      timestamp=$(${prev.coreutils}/bin/date +%s)

      token=$(cat /run/secrets/pushover_api_key)
      user=$(cat /run/secrets/pushover_user_key)

      ${prev.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''${timestamp}" \
        --form-string "title=MDADM Event" \
        --form-string "message=''${message}" \
        https://api.pushover.net/1/messages.json
    '';
  };

  smartd-notif-event = prev.writeShellApplication {
    name = "smartd-notif-event";
    runtimeInputs = [
      prev.curl
      prev.coreutils
    ];
    text = ''
      # shellcheck disable=SC2116
      message=$(echo "''${SMARTD_DEVICE}: ''${SMARTD_FULLMESSAGE}")

      token=$(cat /run/secrets/pushover_api_key)
      user=$(cat /run/secrets/pushover_user_key)

      ${prev.curl}/bin/curl \
        --retry 5 \
        --retry-delay 30 \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "timestamp=''${SMARTD_TFIRSTEPOCH}" \
        --form-string "title=smartd Event" \
        --form-string "message=''${message}" \
        https://api.pushover.net/1/messages.json
    '';
  };
}
