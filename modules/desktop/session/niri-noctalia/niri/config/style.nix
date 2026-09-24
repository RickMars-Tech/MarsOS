{
  flake.wrapperModules.niriLayout.config = {
    extraSettings = [
      {
        include = [
          { optional = true; }
          "~/.config/niri/noctalia.kdl"
        ];
      }
    ];
    settings = {
      # Layout and Misc
      cursor = {
        xcursor-size = 20;
        xcursor-theme = "Bibata-Modern-Classic";
      };

      blur = {
        passes = 2; # more passes = stronger blur (default: 3)
        offset = 3.0; # sample distance per pass (default: 3.0)
        noise = 0.03; # grain overlay (default: 0.02)
        saturation = 1.0; # color saturation boost (default: 1.5)
      };

      layout = {
        gaps = 5;
        background-color = "transparent";
        focus-ring = {
          # off = _: { };
          width = 1.0;
        };
        border = {
          off = _: { };
        };
        tab-indicator = {
          hide-when-single-tab = _: { };
          place-within-column = _: { };
          position = "left";
          corner-radius = 10;
          gap = 5;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length = _: {
            _props = {
              total-proportion = 0.1;
            };
          };
        };
        center-focused-column = "on-overflow";
        always-center-single-column = _: { };
        default-column-width.proportion = 1.0 / 2.0;
        preset-window-heights = [
          { proportion = 1.0; }
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0; }
        ];
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
      };

      recent-windows.highlight = {
        corner-radius = 12;
      };

      gestures = {
        dnd-edge-view-scroll = {
          trigger-width = 30;
          delay-ms = 15;
          max-speed = 1500;
        };
        hot-corners.off = _: { };
      };

      overview = {
        # workspace-shadow.off = _: { };
        zoom = 0.70;
        backdrop-color = "transparent";
      };

      prefer-no-csd = _: { };
      hotkey-overlay.skip-at-startup = _: { };
    };
  };
}
