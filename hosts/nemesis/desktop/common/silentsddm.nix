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
    settings."LoginScreen.LoginArea.Avatar".shape = "circle";
  };
}
