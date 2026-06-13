{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.modules.home.git = {
    enable = lib.mkEnableOption "Git Configuration";
  };

  config = lib.mkIf config.modules.home.git.enable {
    home-manager.users.face.programs.git = {
      ############################################
      # Git Config
      ############################################
      enable = true;
      lfs.enable = true;

      settings = {
        user.name = "Alex Westerman";
        user.email = "alex@faceftw.dev";
        init.defaultBranch = "main";
        core.editor = "vim";
        core.autocrlf = "input";
        commit.gpgsign = true;
        pull.rebase = true;
        rebase.autoStash = true;
      };

      signing.key = "CB9CCE0E558306B21891063A9EB573C02E056DA8";
      signing.signer = "${pkgs.gnupg}/bin/gpg --default-key 2e056da8";
      ignores = [
        "*.swp"
        ".envrc"
        ".direnv/*"
      ];
    };
  };
}
