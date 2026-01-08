{  ... }:
{
  home-manager.users.face = {
    programs.wofi.enable = true;
    programs.wofi.style = ./assets/wofi.css;
    programs.wofi.settings.width = 600;
    programs.wofi.settings.height = 500;
    programs.wofi.settings.location = "center";
    programs.wofi.settings.show = "drun";
    programs.wofi.settings.prompt = "Apps";
    programs.wofi.settings.filter_rate = 100;
    programs.wofi.settings.allow_markup = true;
    programs.wofi.settings.no_actions = true;
    programs.wofi.settings.halign = "fill";
    programs.wofi.settings.orientation = "vertical";
    programs.wofi.settings.content_halign = "fill";
    programs.wofi.settings.insensitive = true;
    programs.wofi.settings.allow_images = true;
    programs.wofi.settings.image_size = 40;
    programs.wofi.settings.gtk_dark = true;
  };
}
