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

        # Other nice aliases
        battery-info = "watch upower -i /org/freedesktop/UPower/devices/battery_BAT1";

        # Nix Specific Aliases
        clean-nix = "sudo nix-collect-garbage -d";
        nix-generations = "nixos-rebuild list-generations";
        rollback-nix = "sudo nixos-rebuild switch --no-reexec --rollback --print-build-logs --flake ~/.config/dotfiles";
        build-fabricator-image = "nix build --max-jobs 8 --keep-going --print-build-logs ~/.config/dotfiles#images.fabricator";
        build-durandal-image = "nix build --max-jobs 8 --keep-going --print-build-logs ~/.config/dotfiles#images.durandal";
      };

      siteFunctions =
        let
          readZFuncDef = path: lib.unsafeDiscardStringContext (lib.readFile path);
        in
        {
          build-closure = readZFuncDef ./../../config/.zfuncs/build-closure.sh;
          deploy-nix = readZFuncDef ./../../config/.zfuncs/deploy-nix.sh;
          deploy-nix-nextboot = readZFuncDef ./../../config/.zfuncs/deploy-nix-nextboot.sh;
          jump-into = readZFuncDef ./../../config/.zfuncs/jump-into.sh;
          push-nix-cache = readZFuncDef ./../../config/.zfuncs/push-nix-cache.sh;
          rebuild-nix = readZFuncDef ./../../config/.zfuncs/rebuild-nix.sh;
          rebuild-nix-nextboot = readZFuncDef ./../../config/.zfuncs/rebuild-nix-nextboot.sh;
          remote-reboot = readZFuncDef ./../../config/.zfuncs/remote-reboot.sh;
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
        "colorize"
        "colored-man-pages"
        "cp"
        "dircycle"
        "fancy-ctrl-z"
        "gh"
        "git-extras"
        "gitfast"
        "lol"
        "npm"
        "rsync"
        "rust"
        "systemd"
        "uv"
        "z"
        # "zsh-autosuggestions"
        # "zsh-syntax-highlighting"
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

          runAfter = lib.mkOrder 1500 "sh-toy";

        in
        lib.mkMerge [
          initFirst
          runAfter
        ];
    };
  };
}
