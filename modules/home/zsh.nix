{
  config,
  lib,
  ...
}:
{
  options.modules.home.zsh = {
    enable = lib.mkEnableOption "ZSH Configuration";
  };

  config = lib.mkIf config.modules.home.zsh.enable {
    home-manager.users.face.programs.zsh = {
      ############################################
      # ZSH Config
      ############################################
      enable = true;
      dotDir = "${config.home-manager.users.face.xdg.configHome}/zsh"; # Using default XDG Home config

      shellAliases = {
        la = "ls -a";
        ll = "ls -al";
        clear = "reset; sh-toy";
        search = "rg -p --glob '!node_modules/*'  $@";
        zshconfig = "vim ~/.zshrc";
        doafunny = "sh-toy";
        clearmemcache = "echo 3 | sudo tee /proc/sys/vm/drop_caches";

        # systemctl aliases
        system-units = "sudo systemctl list-units";
        user-units = "sudo systemctl --user list-units";
        service-status = "sudo systemctl status";
        user-service-status = "systemctl --user status";
        syslog = "sudo journalctl";

        # Other nice aliases
        battery-info = "watch upower -i /org/freedesktop/UPower/devices/battery_BAT1";

        # Nix Specific Aliases
        clean-nix = "sudo nix-collect-garbage -d";
        nix-generations = "nixos-rebuild list-generations";
        rollback-nix = "sudo nixos-rebuild switch --no-reexec --rollback --print-build-logs --flake ~/.config/dotfiles";
        build-fabricator-image = "nix build --max-jobs 8 --keep-going --print-build-logs ~/.config/dotfiles#images.fabricator";
        build-durandal-image = "nix build --max-jobs 8 --keep-going --print-build-logs ~/.config/dotfiles#images.durandal";
        build-port-authority-image = "nix build --max-jobs 8 --keep-going --print-build-logs ~/.config/dotfiles#images.port-authority";
      };

      history = {
        append = true;
        share = true;
        saveNoDups = true;
        ignoreAllDups = true;
        ignorePatterns = [
          "cd *"
          "ls*"
          "pwd"
          "git add \."
          "git commit *"
        ];
      };
      historySubstringSearch.enable = true;

      oh-my-zsh.enable = true;
      oh-my-zsh.extraConfig = "zstyle ':omz:update' mode disabled";
      oh-my-zsh.plugins = [
        "z"
        "colorize"
        "colored-man-pages"
        "cp"
        "vscode"
      ];

      initContent =
        let
          initFirst = lib.mkOrder 500 ''
            if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
              . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
              . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
            fi

            export PATH=$HOME/.local/share/bin:$PATH
          '';

          nix-utils = lib.mkOrder 1200 ''
            function build-closure() {
              ### PARAMETERS
              host=$1
              shift 1
              ### END PARAMETERS

              case "$host" in
              manifold-wsl) host="manifold" ;;
              portal-wsl) host="portal" ;;
              esac

              nix build \
                --print-build-logs \
                --keep-going \
                --no-link \
                "/home/face/.config/dotfiles#nixosConfigurations.$host.config.system.build.toplevel" \
                "$@"
            }

            function push-closure() {
              ### PARAMETERS
              host=$1
              shift 1
              ### END PARAMETERS

              case "$host" in
              manifold-wsl) host="manifold" ;;
              portal-wsl) host="portal" ;;
              esac

              nix copy --to 's3://nix-cache?region=archiver&endpoint=192.168.0.172:3900&scheme=http' \
                "/home/face/.config/dotfiles#nixosConfigurations.$host.config.system.build.toplevel" \
                "$@"
            }

            function push-nix-cache() {
              sudo nix store sign --all \
                --key-file /etc/secrets/nix-cache.pem

              nix copy --all \
                --to 's3://nix-cache?endpoint=s3.garage.faceftw.local&scheme=http&region=archiver' \
                --option narinfo-cache-positive-ttl 0
            }

            function rebuild-nix() {
              ### PARAMETERS
              ### END PARAMETERS

              hostname=$(cat /etc/hostname)
              case "$hostname" in
              manifold-wsl) hostname="manifold" ;;
              portal-wsl) hostname="portal" ;;
              esac

              sudo nixos-rebuild switch \
                --print-build-logs \
                --keep-going \
                --no-reexec \
                --flake "/home/face/.config/dotfiles#$hostname" \
                "$@"
            }

            function rebuild-nix-nextboot() {
              ### PARAMETERS
              ### END PARAMETERS

              hostname=$(cat /etc/hostname)
              case "$hostname" in
              manifold-wsl) hostname="manifold" ;;
              portal-wsl) hostname="portal" ;;
              esac

              sudo nixos-rebuild boot \
                --print-build-logs \
                --keep-going \
                --no-reexec \
                --flake "/home/face/.config/dotfiles#$hostname" \
                "$@"
            }

            function deploy-nix() {
              ### PARAMETERS
              host=$1
              addr=$2
              shift 2
              ### END PARAMETERS
              nixos-rebuild switch \
                --print-build-logs \
                --keep-going \
                --no-reexec \
                --flake "/home/face/.config/dotfiles#$host" \
                --sudo --ask-sudo-password \
                --target-host "face@$addr" \
                "$@"
            }

            function deploy-nix-nextboot() {
              ### PARAMETERS
              host=$1
              addr=$2
              shift 2
              ### END PARAMETERS
              nixos-rebuild boot \
                --print-build-logs \
                --keep-going \
                --no-reexec \
                --flake "/home/face/.config/dotfiles#$host" \
                --sudo --ask-sudo-password \
                --target-host "face@$addr" \
                "$@"
            }
          '';

          misc-utils = lib.mkOrder 1300 ''
            function setup-envrc() {
              ### PARAMETERS
              path=$1
              shellName=$2
              ### PARAMETERS
              echo "use flake ~/.config/dotfiles#$shellName" > "$path/.envrc"
              current_dir=$(pwd)
              cd "$path"
              direnv allow
              cd "$current_dir"
            }
          '';

          runAfter = lib.mkOrder 1500 "sh-toy";

        in
        lib.mkMerge [
          initFirst
          nix-utils
          misc-utils
          runAfter
        ];
    };
  };
}
