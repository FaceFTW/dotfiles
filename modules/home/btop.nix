{
  config,
  lib,
  ...
}:
{
  options.modules.home.btop = {
    enable = lib.mkEnableOption "oh-my-posh Configuration";
  };

  config = lib.mkIf config.modules.home.btop.enable {
    home-manager.users.face.programs.btop = {

      enable = true;
      settings.color_theme = "TTY";
      settings.theme_background = true;
      settings.force_tty = false;
      settings.terminal_sync = true;
      settings.clock_format = "/host - %x %X";
      settings.presets = "cpu:0:default,mem:0:default,net:0:default";
      settings.update_ms = 2000;
      settings.log_level = "WARNING";

      settings.graph_symbol = "block";
      settings.graph_symbol_cpu = "tty";
      settings.graph_symbol_mem = "tty";
      settings.graph_symbol_net = "block";
      settings.shown_boxes = "mem cpu net";

      settings.cpu_graph_upper = "total";
      settings.cpu_graph_lower = "system";
      settings.cpu_single_graph = false;
      settings.cpu_bottom = false;
      settings.show_uptime = true;
      settings.show_cpu_watts = true;
      settings.check_temp = true;
      settings.cpu_sensor = "Auto";
      settings.show_coretemp = true;
      settings.temp_scale = "celsius";
      settings.base_10_sizes = false;
      settings.show_cpu_freq = true;

      settings.mem_graphs = false;
      settings.mem_below_net = false;
      settings.show_swap = true;

      settings.show_disks = true;
      settings.disks_filter = "/mnt/archive /mnt/motorway";
      settings.swap_disk = false;
      settings.use_fstab = true;
      settings.zfs_hide_datasets = true;
      settings.disk_free_priv = true;
      settings.show_io_stat = false;

      settings.net_auto = true;
      settings.net_sync = true;
      settings.net_iface = "enp2s0";
      settings.base_10_bitrate = "false";
      settings.show_battery = false;

    };
  };
}
