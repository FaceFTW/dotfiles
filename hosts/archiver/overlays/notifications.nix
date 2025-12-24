final: prev: {
  mdadm-notif-event = prev.writeShellApplication {
    name = "mdadm-notif-event";
    runtimeInputs = [ prev.curl ];
    text = ''
      event_type=$1
      affected_device=$2
      related_device=''${3:-"N/A"}

      message="MDADM Event: ''${event_type} on ''${affected_device}. Related Devices: ''${related_device}"

      token=$(cat /run/secrets/pushover_api_key)
      user=$(cat /run/secrets/pushover_user_key)

      ${prev.curl}/bin/curl \
        --form-string "token=''${token}" \
        --form-string "user=''${user}" \
        --form-string "message=''${message}" \
        https://api.pushover.net/1/messages.json
    '';
  };
}
