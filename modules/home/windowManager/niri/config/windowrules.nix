{
  programs.niri.settings = {
    layer-rules = [
      #= Wallpaper
      {
        matches = [{namespace = "^wpaperd-HDMI-A-1$";}];
        place-within-backdrop = true;
      }
      {
        matches = [{namespace = "^wpaperd-eDP-1$";}];
        place-within-backdrop = true;
      }
      #= Ironbar
      # {
      #   matches = [{namespace = "^ironbar$";}];
      #   opacity = 0.90;
      #   place-within-backdrop = true;
      # }
    ];
    # See app-id with command = $ niri msg windows
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
        matches = [{app-id = "org.wezfurlong.wezterm";}];
        default-column-width = {proportion = 1.0;};
      }
      {
        matches = [
          {
            title = "yazi";
            app-id = "org.wezfurlong.wezterm";
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
        matches = [{app-id = "steam";}];
        default-column-width = {proportion = 1.0;};
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
