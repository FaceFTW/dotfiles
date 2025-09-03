{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "face";
in
{
  # Shared shell configuration
  zsh = {
    enable = true;

    #History Configuration
    history.append = true;
    history.ignoreAllDups = true;
    history.ignorePatterns = [
      "cd *"
      "ls"
      ""
    ];
    history.share = true;
    historySubstringSearch.enable = true;

    # Oh My ZSH Configuration
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = [
      "z"
      "colorize"
      "colored-man-pages"
      "dircycle"
      "cp"
      "lol"
      "vscode"
      "ssh-agent"
      "gpg-agent"
    ];
    oh-my-zsh.extraConfig = ''
      zstyle ':omz:update' mode disabled
      zstyle :omz:plugins:keychain agents gpg,ssh
      zstyle :omz:plugins:keychain options --quiet --quick --noask
      zstyle :omz:plugins:ssh-agent lazy yes
    '';

    initContent =
      let
        initFirst = lib.mkOrder 500 ''
          if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
          fi

          # Define variables for directories
          export PATH=$HOME/.local/share/bin:$PATH

          # Remove history data we don't want to see
          export HISTIGNORE="pwd:ls:cd"


          shell() {
              nix-shell '<nixpkgs>' -A "$1"
          }

          alias search=rg -p --glob '!node_modules/*'  $@
          alias zshconfig="vim ~/.zshrc"
          alias doafunny="sh-toy"
          alias clearmemcache="echo 3 | sudo tee /proc/sys/vm/drop_caches"

          alias clear="/bin/clear; sh-toy"

        '';

        runAfter = lib.mkOrder 1500 "sh-toy";

      in
      lib.mkMerge [
        initFirst
        runAfter
      ];
  };

  oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (
      builtins.unsafeDiscardStringContext (builtins.readFile "${./../../config/omp-theme.json}")
    );
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = "Alex Westerman";
    userEmail = "alex@faceftw.dev";
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  # vim = {
  #   enable = true;
  #   plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
  #   settings = { ignorecase = true; };
  #   extraConfig =
  # };

  ssh = {
    enable = true;
    # includes = [
    #   (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
    #     "/home/${user}/.ssh/config_external"
    #   )
    # ];

  };

}
