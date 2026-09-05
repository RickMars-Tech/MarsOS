{
  flake.wrapperModules.niriOutputs =
    {
      pkgs,
      lib,
      ...
    }:
    {
      config.settings = {
        # Outputs
        outputs = {
          "eDP-1" = {
            mode = "1920x1080";
            variable-refresh-rate = _: { on-demand = true; };
            scale = 1.0;
            position = _: {
              props = {
                x = 0;
                y = 0;
              };
            };
            layout.always-center-single-column = _: { };
          };
          "HDMI-A-1" = {
            mode = "1920x1080";
            scale = 1.0;
          };
        };
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      };
    };
}
