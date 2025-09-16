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
  ############################################
  # ZSH Config
  ############################################
  zsh.enable = true;

  zsh.shellAliases.la = "ls -a";
  zsh.shellAliases.ll = "ls -al";
  zsh.shellAliases.clear = "clear-scrollback-buffer; sh-toy";
  zsh.shellAliases.search = "rg -p --glob '!node_modules/*'  $@";
  zsh.shellAliases.zshconfig = "vim ~/.zshrc";
  zsh.shellAliases.doafunny = "sh-toy";
  zsh.shellAliases.clearmemcache = "echo 3 | sudo tee /proc/sys/vm/drop_caches";

  # Nix Specific Aliases
  zsh.shellAliases.clean-nix = "sudo nix-collect-garbage -d";
  zsh.shellAliases.nix-generations = "nixos-rebuild list-generations";
  zsh.shellAliases.build-manifold-image = "sudo nix run ~/.config/dotfiles#nixosConfigurations.manifold.config.system.build.tarballBuilder";
  zsh.shellAliases.rebuild-manifold = "sudo nixos-rebuild switch --flake ~/.config/dotfiles#manifold";
  zsh.shellAliases.rebuild-manifold-trace = "sudo nixos-rebuild switch --show-trace --flake ~/.config/dotfiles#manifold";
  zsh.shellAliases.build-portal-image = "sudo nix run .#nixosConfigurations.portal.config.system.build.tarballBuilder";
  zsh.shellAliases.rebuild-portal = "sudo nixos-rebuild switch --flake ~/.config/dotfiles#portal";
  zsh.shellAliases.rebuild-portal-trace = "sudo nixos-rebuild switch --show-trace --flake ~/.config/dotfiles#portal";
  zsh.shellAliases.build-fabricator-image = "nix build .$images.fabricator";
  # zsh.shellAliases.rebuild-fabricator = "sudo nixos-rebuild switch --flake ~/.config/dotfiles#portal";
  # zsh.shellAliases.rebuild-fabricator-trace = "sudo nixos-rebuild switch --show-trace --flake /";

  zsh.history.append = true;
  zsh.history.ignoreAllDups = true;
  zsh.history.ignorePatterns = [
    "cd *"
    "ls*"
    "pwd"
  ];
  zsh.history.share = true;
  zsh.historySubstringSearch.enable = true;

  zsh.oh-my-zsh.enable = true;
  zsh.oh-my-zsh.plugins = [
    "z"
    "colorize"
    "colored-man-pages"
    "cp"
    "vscode"
    "ssh-agent"
    "gpg-agent"
  ];
  zsh.oh-my-zsh.extraConfig = ''
    zstyle ':omz:update' mode disabled
    zstyle :omz:plugins:keychain agents gpg,ssh
    zstyle :omz:plugins:keychain options --quiet --quick --noask
    zstyle :omz:plugins:ssh-agent lazy yes
  '';

  zsh.initContent =
    let
      initFirst = lib.mkOrder 500 ''
        if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fi

        export PATH=$HOME/.local/share/bin:$PATH

        # https://unix.stackexchange.com/questions/517025/zsh-clear-scrollback-buffer
        function clear-scrollback-buffer {
          clear && printf '\e[3J'
          zle && zle .reset-prompt && zle -R
        }
      '';

      runAfter = lib.mkOrder 1500 "sh-toy";

    in
    lib.mkMerge [
      initFirst
      runAfter
    ];

  ############################################
  # Oh My Posh Config
  ############################################
  oh-my-posh.enable = true;
  oh-my-posh.enableZshIntegration = true;
  oh-my-posh.settings = builtins.fromJSON (
    builtins.unsafeDiscardStringContext (builtins.readFile "${./../dotfiles/omp-theme.json}")
  );

  ############################################
  # Git Config
  ############################################
  git.enable = true;
  git.ignores = [ "*.swp" ];
  git.userName = "Alex Westerman";
  git.userEmail = "alex@faceftw.dev";
  git.lfs.enable = true;
  git.extraConfig.init.defaultBranch = "main";
  git.extraConfig.core.editor = "vim";
  git.extraConfig.core.autocrlf = "input";
  git.extraConfig.commit.gpgsign = true;
  git.extraConfig.pull.rebase = true;
  git.extraConfig.rebase.autoStash = true;
  git.signing.key = "CB9CCE0E558306B21891063A9EB573C02E056DA8";

  ############################################
  # Vim Config
  ############################################
  vim.enable = true;
  vim.plugins = with pkgs.vimPlugins; [
    vim-fugitive
    vim-polyglot
    fzf-vim
    neoformat
    ale
    vim-startify
    lightline-vim
    undotree
    vim-peekaboo
    delimitMate
  ];
  vim.defaultEditor = true;
  vim.settings.ignorecase = true;
  vim.extraConfig =
    builtins.replaceStrings [ "let g:skip_plug_load = 0" ] [ "let g:skip_plug_load = 1" ]
      (builtins.unsafeDiscardStringContext (builtins.readFile "${./../dotfiles/.vimrc}"));

  ############################################
  # SSH Config
  ############################################
  ssh.enable = true;
  ssh.enableDefaultConfig = false;

}
