{
  programs.ironbar.config = {
    anchor_to_edges = true;
    position = "top";
    height = 24; # Aumentado de 16 para mejor visibilidad
    start = [
      # Workspaces
      {
        type = "workspaces";
        all_monitors = true;
        sort = "added";
      }
      {
        type = "focused";
        show_icon = false;
      }
    ];
    center = [
      {
        type = "clock";
        format = "%H:%M";
        format_popup = "%d/%m/%Y";
      }
    ];
    end = [
      {
        type = "tray";
        icon_size = 16;
      }
      {
        type = "clipboard";
        max_items = 8;
      }
      {
        type = "notifications";
        show_count = false;
        icons.closed_none = "󰍥";
        icons.closed_some = "󱥂";
        icons.closed_dnd = "󱅯";
        icons.open_none = "󰍡";
        icons.open_some = "󱥁";
        icons.open_dnd = "󱅮";
      }
      {
        type = "volume";
        format = "{icon}";
        max_volume = 100;
        truncate.mode = "end";
        truncate.length = 50;
        icons = {
          volume_high = "";
          volume_medium = "";
          volume_low = "";
          muted = "";
        };
      }
      {
        type = "battery";
        show_if = "upower -e | grep BAT";
        icon_size = 16;
        format = "{percentage}%";
        thresholds = {
          warning = 20;
          critical = 5;
        };
      }
    ];
  };
}
