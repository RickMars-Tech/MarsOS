{
  flake.wrapperModules.niriWindowrules.config.settings = {
    # WindowRules
    window-rules = [
      {
        geometry-corner-radius = 20;
        default-column-width.proportion = 0.8;
        clip-to-geometry = true;
        tiled-state = true;
        draw-border-with-background = false;
        background-effect = {
          blur = true;
          xray = false;
        };
        popups = {
          geometry-corner-radius = 15;
          opacity = 0.85;
          background-effect = {
            blur = true;
            xray = false;
          };
        };
      }
      {
        matches = [ { app-id = "^(firefox|chromium-browser|chrome-.*|firefox-.*)$"; } ];
        open-on-workspace = "ws2";
        scroll-factor = 0.5;
      }
      {
        matches = [ { app-id = "^(xdg-desktop-portal-gtk)$"; } ];
        scroll-factor = 0.5;
      }
      {
        matches = [ { app-id = "org.wezfurlong.wezterm|com.mitchellh.ghostty"; } ];
        open-on-workspace = "ws1";
        draw-border-with-background = false;
      }
      {
        matches = [
          { title = "Yazi-.*"; }
          { app-id = "org.wezfurlong.wezterm|com.mitchellh.ghostty"; }
        ];
        open-on-workspace = "ws1";
        draw-border-with-background = false;
      }
      {
        matches = [ { app-id = "org.gnome.Nautilus"; } ];
        default-column-width.proportion = 0.5;
      }
      {
        matches = [ { app-id = "dev.noctalia.Noctalia.Settings"; } ];
        default-column-width.proportion = 0.5;
      }
      {
        matches = [ { app-id = "org.gnome.*"; } ];
        draw-border-with-background = false;
        geometry-corner-radius = 12;
        clip-to-geometry = true;
      }
      {
        matches = [ { app-id = "mpv"; } ];
        open-on-workspace = "ws3";
        open-maximized = true;
      }
      {
        matches = [ { app-id = "steam"; } ];
        open-on-workspace = "ws3";
        default-column-width.proportion = 1.0;
      }
      {
        matches = [
          { title = "Friends List"; }
          { app-id = "steam"; }
        ];
        open-on-workspace = "ws3";
        default-column-width.fixed = 340;
      }
      {
        matches = [ { app-id = "Waydroid"; } ];
        default-column-width.fixed = 1256;
      }
      {
        matches = [ { app-id = ".*exe"; } ];
        open-on-workspace = "ws4";
        variable-refresh-rate = true;
      }
    ];

    layer-rules = [
      # Blury Overview with Noctalia
      {
        matches = [ { namespace = "^noctalia-backdrop*"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel)$"; } ];
        background-effect = {
          xray = false;
        };
        popups = {
          geometry-corner-radius = 15;
          opacity = 0.85;
          background-effect = {
            blur = true;
            xray = false;
          };
        };
      }
    ];
  };
}
