{
  programs.niri.settings._children = [
    {
      output = {
        _args = ["eDP-1"];
        mode = "1920x1080";
        variable-refresh-rate._props = {on-demand = true;};
        scale = 1.0;
        position._props = {
          x = 0;
          y = 0;
        };
        layout = {
          always-center-single-column = {};
        };
      };
    }
    {
      output = {
        _args = ["HDMI-A-1"];
        mode = "1920x1080";
        scale = 1.0;
        # position._props = {
        # x = 0;
        # y = 0;
        # };
      };
    }
  ];
}
