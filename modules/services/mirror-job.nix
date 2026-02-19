{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    concatMapStrings
    ;
  jobSpec =
    with types;
    submodule {
      options.cron = mkOption {
        type = types.str;
        description = "Cron time to use with the timer unit";
      };

      options.mounts = mkOption {
        type = with types; listOf str;
        description = "List of systemd mounts that this mirror needs to run successfully";
        default = [ ];
      };

      options.notification-title = mkOption {
        type = types.str;
        description = "Title to use in the Pushover notification";
      };

      options.source = mkOption {
        type = types.str;
        description = "Source directory to use. Note that it will use contents of directory, not transplanting the dir.";
      };

      options.destination = mkOption {
        type = types.str;
        description = "Destination directory to use.";
      };

      options.exclude = mkOption {
        type = with types; listOf str;
        description = "List of paths to exclude in the mirror";
        default = [ ];
      };

      options.post-mirror-cmds = mkOption {
        type = types.str;
        description = "Commands to run after the main mirror command is finished";
        default = "";
      };
    };

  mkJob =
    name:
    {
      cron,
      mounts,
      notification-title,
      source,
      destination,
      exclude,
      post-mirror-cmds,
      ...
    }:
    let
      excludes = concatMapStrings (x: "  --exclude ${x} \\\\n") exclude;
    in
    {

      wants = mounts;
      serviceConfig.Type = "oneshot";
      script = ''
        token=$(cat /run/secrets/pushover_api_key)
        user=$(cat /run/secrets/pushover_user_key)

        ${pkgs.curl}/bin/curl \
          --retry 5 \
          --retry-delay 30 \
          --form-string "token=''${token}" \
          --form-string "user=''${user}" \
          --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
          --form-string "title=${notification-title}" \
          --form-string "message=Starting backup job" \
          https://api.pushover.net/1/messages.json


        ${pkgs.rsync}/bin/rsync -aPt \
            --archive \
            --partial \
            --progress \
            --delete-before \
            ${excludes} \
            ${source}/ \
            ${destination}

        ${post-mirror-cmds}

        ${pkgs.curl}/bin/curl \
          --retry 5 \
          --retry-delay 30 \
          --form-string "token=''${token}" \
          --form-string "user=''${user}" \
          --form-string "timestamp=''$(${pkgs.coreutils}/bin/date +%s)" \
          --form-string "title=${notification-title}" \
          --form-string "message=Backup Job completed. Check logs for more info" \
          https://api.pushover.net/1/messages.json
      '';
    };

  mkTimer =
    name:
    {
      cron,
      ...
    }:
    {

      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "${cron}";
      timerConfig.Persistent = true;

    };

  mirrorCfg = config.servicesCustom.mirror;
in
{
  options.servicesCustom.mirror = mkOption {
    type = with types; attrsOf jobSpec;
    default = { };
  };

  config = {
    systemd.timers =
      let
        timerDefs = lib.mapAttrs' (name: jobDef: {
          name = "${name}-mirror";
          value = (mkTimer name jobDef);
        }) mirrorCfg;
      in
      timerDefs;
    systemd.services =
      let
        jobDefs = lib.mapAttrs' (name: jobDef: {
          name = "${name}-mirror";
          value = (mkJob name jobDef);
        }) mirrorCfg;
      in
      jobDefs;
  };
}
