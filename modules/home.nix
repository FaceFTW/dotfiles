{
  config,
  pkgs,
  lib,
  ...
}:
let
  fromRepoJson = with lib; path: fromJSON (unsafeDiscardStringContext (readFile path));
in
{
  ############################################
  # ZSH Config
  ############################################
  zsh.enable = true;
  zsh.dotDir = "${config.home-manager.users.face.xdg.configHome}/zsh"; # Using default XDG Home config

  zsh.shellAliases.la = "ls -a";
  zsh.shellAliases.ll = "ls -al";
  zsh.shellAliases.clear = "reset; sh-toy";
  zsh.shellAliases.search = "rg -p --glob '!node_modules/*'  $@";
  zsh.shellAliases.zshconfig = "vim ~/.zshrc";
  zsh.shellAliases.doafunny = "sh-toy";
  zsh.shellAliases.clearmemcache = "echo 3 | sudo tee /proc/sys/vm/drop_caches";

  # systemctl aliases
  zsh.shellAliases.system-units = "sudo systemctl list-units";
  zsh.shellAliases.user-units = "sudo systemctl --user list-units";
  zsh.shellAliases.service-status = "sudo systemctl status";
  zsh.shellAliases.user-service-status = "systemctl --user status";

  # Other nice aliases
  zsh.shellAliases.battery-info = "watch upower -i /org/freedesktop/UPower/devices/battery_BAT1";

  # Nix Specific Aliases
  zsh.shellAliases.clean-nix = "sudo nix-collect-garbage -d";
  zsh.shellAliases.nix-generations = "nixos-rebuild list-generations";
  zsh.shellAliases.rollback-nix = "sudo nixos-rebuild switch --no-reexec --rollback --print-build-logs --flake ~/.config/dotfiles";
  zsh.shellAliases.build-fabricator-image = "nix build --max-jobs 8 --keep-going --print-build-logs ~/.config/dotfiles#images.fabricator";

  zsh.history.append = true;
  zsh.history.ignoreAllDups = true;
  zsh.history.ignorePatterns = [
    "cd *"
    "ls*"
    "pwd"
    "git add \."
    "git commit *"
  ];
  zsh.history.share = true;
  zsh.history.saveNoDups = true;
  zsh.historySubstringSearch.enable = true;

  zsh.oh-my-zsh.enable = true;
  zsh.oh-my-zsh.plugins = [
    "z"
    "colorize"
    "colored-man-pages"
    "cp"
    "vscode"
  ];
  zsh.oh-my-zsh.extraConfig = ''
    zstyle ':omz:update' mode disabled
  '';

  zsh.initContent =
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
          portal-wsl) hostname="portal" ;;
          esac

          nix build \
            --print-build-logs \
            --keep-going \
            --no-link \
            "/home/face/.config/dotfiles#nixosConfigurations.$host.config.system.build.toplevel" \
            "$@"
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

  ############################################
  # Oh My Posh Config
  ############################################
  oh-my-posh.enable = true;
  oh-my-posh.enableZshIntegration = true;
  oh-my-posh.settings = fromRepoJson "${./../config/omp-theme.json}";

  ############################################
  # Git Config
  ############################################
  git.enable = true;
  git.lfs.enable = true;
  git.settings.user.name = "Alex Westerman";
  git.settings.user.email = "alex@faceftw.dev";
  git.settings.init.defaultBranch = "main";
  git.settings.core.editor = "vim";
  git.settings.core.autocrlf = "input";
  git.settings.commit.gpgsign = true;
  git.settings.pull.rebase = true;
  git.settings.rebase.autoStash = true;
  git.signing.key = "CB9CCE0E558306B21891063A9EB573C02E056DA8";
  git.signing.signer = "${pkgs.gnupg}/bin/gpg --default-key 2e056da8";
  git.ignores = [
    "*.swp"
    ".envrc"
    ".direnv/*"
  ];

  ############################################
  # SSH Client Config
  ############################################
  ssh.enable = true;
  ssh.enableDefaultConfig = false;
  ssh.extraConfig = "AddKeysToAgent yes";
  ssh.matchBlocks."*" = { };

  ############################################
  # fastfetch Config
  ############################################
  fastfetch.enable = true;
  fastfetch.settings = fromRepoJson "${./../config/fastfetch.jsonc}";

}
