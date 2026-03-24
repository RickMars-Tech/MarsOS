{
  programs.niri.settings._children = [
    # Noctalia
    {
      layer-rule._children = [
        {
          match._props = {namespace = "^noctalia-wallpaper*";};
          place-within-backdrop = true;
        }
      ];
    }

    # Windows Rules
    {
      window-rule._children = [
        {
          geometry-corner-radius = 20;
          default-column-width = {proportion = 0.8;};
          clip-to-geometry = true;
          tiled-state = true;
          draw-border-with-background = false;
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = "^(firefox|chromium-browser|chrome-.*|firefox-.*)$";};
          open-on-workspace = "chat";
          scroll-factor = 0.5;
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = "^(xdg-desktop-portal-gtk)$";};
          scroll-factor = 0.5;
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = "org.wezfurlong.wezterm|com.mitchellh.ghostty";};
          open-on-workspace = "dev";
          draw-border-with-background = false;
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {
            title = "Yazi-.*";
            app-id = "org.wezfurlong.wezterm|com.mitchellh.ghostty";
          };
          open-on-workspace = "dev";
          draw-border-with-background = false;
          default-column-width = {proportion = 0.25;};
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = "org.gnome.Nautilus";};
          default-column-width = {proportion = 0.5;};
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = "mpv";};
          open-on-workspace = "chat";
          open-maximized = true;
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = "steam";};
          open-on-workspace = "gaming";
          default-column-width = {proportion = 1.0;};
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {
            title = "Friends List";
            app-id = "steam";
          };
          open-on-workspace = "gaming";
          default-column-width = {fixed = 340;};
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = "Waydroid";};
          default-column-width = {fixed = 1256;};
        }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {app-id = ".*exe";};
          open-on-workspace = "gaming";
          variable-refresh-rate = true;
        }
      ];
    }
  ];
}
