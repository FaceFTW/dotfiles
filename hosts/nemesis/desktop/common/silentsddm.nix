{
  ...
}:
{
  # This replaces SDDM configuration
  services.displayManager.defaultSession = "hyprland";
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    profileIcons.face = ./face.png;


    settings."LockScreen.Message".font-size = 22;
    settings."LockScreen.Message".icon-size = 28;

    settings."LoginScreen.LoginArea.Avatar".shape = "circle";
    settings."LoginScreen.LoginArea.Avatar".active-size = 160;

    settings."LoginScreen.LoginArea.Username".font-size = 28;

    settings."LoginScreen.LoginArea.PasswordInput".width = 250;
    settings."LoginScreen.LoginArea.PasswordInput".height = 37;
    settings."LoginScreen.LoginArea.PasswordInput".font-size = 20;
    settings."LoginScreen.LoginArea.PasswordInput".icon-size = 26;

    settings."LoginScreen.LoginArea.LoginButton".icon-size = 26;

    settings."LoginScreen.LoginArea.Spinner".font-size = 28;
    settings."LoginScreen.LoginArea.Spinner".icon-size = 48;

    settings."LoginScreen.LoginArea.WarningMessage".icon-size = 22;

    settings."LoginScreen.MenuArea.Buttons".size = 28;
    # settings."LoginScreen.MenuArea.Buttons".spacing = 20;

    settings."LoginScreen.MenuArea.Popups".item-height = 48;
    settings."LoginScreen.MenuArea.Popups".item-spacing = 4;
    settings."LoginScreen.MenuArea.Popups".font-size = 22;
    settings."LoginScreen.MenuArea.Popups".icon-size = 28;

    settings."LoginScreen.MenuArea.Power".icon-size = 28;
    settings."LoginScreen.MenuArea.Power".popup-width = 250;

    settings."LoginScreen.MenuArea.Session".display = false;
    settings."LoginScreen.MenuArea.Layout".display = false;
    settings."LoginScreen.MenuArea.Keyboard".display = false;

    settings."Tooltips".font-size = 22;

  };
}
