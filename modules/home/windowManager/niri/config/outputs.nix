_: {
  #= Displays
  programs.niri.settings.outputs = {
    "eDP-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 144.000;
      };
      variable-refresh-rate = "on-demand";
      scale = 1.0;
      position = {
        x = 0;
        y = 0;
      };
    };
    "HDMI-A-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = null;
      };
      scale = 1.0;
      position = {
        x = 0;
        y = -1080;
      };
    };
    "LVDS-1" = {
      mode = {
        width = 1366;
        height = 768;
        refresh = null;
      };
      scale = 1.0;
      position = {
        x = 0;
        y = -768;
      };
    };
  };
}
