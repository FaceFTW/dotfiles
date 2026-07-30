{
  pkgs,
  inputs,
  ...
}:
let
  vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
in
{

  home-manager.users.face = {
    imports = [
      inputs.vicinae.homeManagerModules.default
    ];
    programs.vicinae.enable = true;
    programs.vicinae.extensions = [
      # vicinae-extensions.bluetooth
      vicinae-extensions.nix
      vicinae-extensions.power-profile
      vicinae-extensions.hypr-keybinds
      # vicinae-extensions.systemd
      vicinae-extensions.firefox
      # vicinae-extensions.dbus

    ];
    programs.vicinae.settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      search_files_in_root = true;
    };
  };
}
