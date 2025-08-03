_: {
  programs.niri.settings = {
    layer-rules = [
      #= Hyprpaper
      {
        matches = [{namespace = "^hyprpaper$";}];
        place-within-backdrop = true;
      }
      #= Quickshell
      {
        matches = [{namespace = "^quickshell$";}];
        opacity = 0.90;
        place-within-backdrop = true;
      }
    ];
    window-rules = [
      {
        geometry-corner-radius = let
          radius = 12.0;
        in {
          bottom-left = radius;
          bottom-right = radius;
          top-left = radius;
          top-right = radius;
        };
        clip-to-geometry = true;
      }
      {
        matches = [
          {app-id = "^(firefox|chromium-browser|chrome-.*|firefox-.*)$";}
          {app-id = "^(xdg-desktop-portal-gtk)$";}
        ];
        scroll-factor = 0.5;
      }
      {
        matches = [{app-id = "firefox";}];
        default-column-width = {proportion = 1.0;};
      }
      {
        matches = [{app-id = "wezterm";}];
        default-column-width = {proportion = 1.0;};
      }
      {
        matches = [
          {
            title = "yazi";
            app-id = "wezterm";
          }
        ];
        default-column-width = {proportion = 0.25;};
      }
      {
        matches = [{app-id = "org.gnome.Nautilus";}];
        default-column-width = {proportion = 0.5;};
      }
      {
        matches = [{app-id = "iwgtk";}];
        default-column-width = {proportion = 0.25;};
      }
      {
        matches = [{app-id = "mpv";}];
        default-column-width = {fixed = 920;};
        open-maximized = true;
      }
      {
        matches = [
          {
            title = "Friends List";
            app-id = "steam";
          }
        ];
        default-column-width = {fixed = 340;};
      }
      {
        matches = [{app-id = "Waydroid";}];
        default-column-width = {fixed = 1256;};
      }
    ];
  };
}
