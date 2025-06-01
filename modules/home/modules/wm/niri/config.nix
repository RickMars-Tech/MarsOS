{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  makeCommand = command: {
    command = [command];
  };
  pointer = config.stylix.cursor;
  color = config.stylix.base16Scheme;
in {
  programs.niri = {
    enable = true;
    package = pkgs.niri; #pkgs.niri-unstable;
    settings = {
      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        #NIXOS_OZONE_WL = "1";
        #= Backend
        GDK_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        DISPLAY = ":0";
      };
      spawn-at-startup = [
        (makeCommand "systemctl --user import-environment")
        (makeCommand "systemctl --user restart pipewire.service")
        (makeCommand "systemctl --user restart xdg-desktop-portal.service")
        #(makeCommand "systemctl --user restart xwayland-satellite.service")
        (makeCommand "xwayland-satellite")
        (makeCommand "systemctl --user restart iwgtk.service")
        #(makeCommand "${lib.getExe pkgs.xwayland-satellite}")
        (makeCommand "wl-clip-persist --clipboard regular")
        (makeCommand "cliphist wipe")
        (makeCommand "systemctl --user start cliphist.service")
        (makeCommand "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2")
        (makeCommand "$POLKIT_BIN")
        (makeCommand "wlr-randr")
        (makeCommand "wpaperd -d")
        (makeCommand "waybar")
        (makeCommand "$TERMINAL")
        {
          command = [
            "${pkgs.dbus}/bin/dbus-update-activation-environment"
            "--systemd"
            "DISPLAY"
            "WAYLAND"
            "WAYLAND_DISPLAY"
            "DBUS_SESSION_BUS_ADDRESS"
            "DISPLAY XAUTHORITY"
            #"SWAYSOCK"
            "XDG_CURRENT_DESKTOP"
            "XDG_SESSION_TYPE"
            "NIXOS_OZONE_WL"
            "XCURSOR_THEME"
            "XCURSOR_SIZE"
            "XDG_DATA_DIRS"
          ];
        }
      ];
      input = {
        keyboard.xkb = {
          layout = "us";
          variant = "intl";
          options = "compose:ralt";
        };
        touchpad = {
          accel-profile = "flat";
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = false;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
        };
        trackpoint = {
          enable = true;
          accel-profile = "flat";
        };
        mouse = {
          enable = true;
          accel-profile = "flat";
          scroll-factor = 1.0;
        };
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus = true;
        workspace-auto-back-and-forth = true;
      };
      outputs = {
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = null;
          };
          scale = 1.0;
          position = {
            x = 0;
            y = -768; #0;
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
            y = 0; #-1080;
          };
        };
      };
      cursor = {
        size = pointer.size;
        theme = "${pointer.name}";
      };
      layout = {
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          active.gradient = {
            angle = 45;
            relative-to = "workspace-view";
            from = color.base0A;
            to = color.base0C;
          };
          inactive.color = "#808080";
        };

        center-focused-column = "on-overflow";

        preset-column-widths = [
          {proportion = 1.0 / 3.0;}
          {proportion = 1.0 / 2.0;}
          {proportion = 2.0 / 3.0;}
          {proportion = 1.0;}
        ];
        default-column-width = {proportion = 1.0 / 2.0;};

        gaps = 5;
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
      };

      animations.shaders.window-resize = ''
        vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
            vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

            vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
            vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

            // We can crop if the current window size is smaller than the next window
            // size. One way to tell is by comparing to 1.0 the X and Y scaling
            // coefficients in the current-to-next transformation matrix.
            bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
            bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

            vec3 coords = coords_stretch;
            if (can_crop_by_x)
                coords.x = coords_crop.x;
            if (can_crop_by_y)
                coords.y = coords_crop.y;

            vec4 color = texture2D(niri_tex_next, coords.st);

            // However, when we crop, we also want to crop out anything outside the
            // current geometry. This is because the area of the shader is unspecified
            // and usually bigger than the current geometry, so if we don't fill pixels
            // outside with transparency, the texture will leak out.
            //
            // When stretching, this is not an issue because the area outside will
            // correspond to client-side decoration shadows, which are already supposed
            // to be outside.
            if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                color = vec4(0.0);
            if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                color = vec4(0.0);

            return color;
        }
      '';

      binds = with config.lib.niri.actions; {
        "XF86AudioMute".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        "XF86AudioRaiseVolume".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        "XF86AudioLowerVolume".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];

        "XF86AudioPlay".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
        "XF86AudioStop".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "pause"];
        "XF86AudioPrev".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "previous"];
        "XF86AudioNext".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "next"];

        #"XF86Calculator".action = ags "recorder.start()";
        #"Print".action = screenshot-screen;
        #"Mod+Shift+Alt+S".action = screenshot-window;
        #"Mod+Shift+S".action = screenshot;
        "Mod+T".action.spawn = ["${pkgs.wezterm}/bin/wezterm"]; #["${inputs.wezterm.packages.${pkgs.system}.default}/bin/wezterm"];
        "Mod+E".action.spawn = ["${pkgs.wezterm}/bin/wezterm" "-e" "yazi"]; #["${inputs.wezterm.packages.${pkgs.system}.default}/bin/wezterm" "-e" "yazi"];
        "Mod+B".action.spawn = ["${lib.getExe pkgs.firefox}"];
        "Mod+R".action.spawn = ["${lib.getExe pkgs.fuzzel}"];
        "Mod+Shift+Q".action.spawn = ["${lib.getExe pkgs.hyprlock}"];
        "Mod+M".action.spawn = ["${lib.getExe pkgs.wlogout}"];

        "Mod+Shift+F9".action = screenshot;
        #"Mod+Shift+F10".action = screenshot-screen;
        #"Mod+Shift+F11".action = screenshot-window;

        "Mod+W".action = toggle-column-tabbed-display;
        "Mod+Q".action = close-window;
        "Mod+S".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+C".action = center-column;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Plus".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Plus".action = set-window-height "+10%";

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-workspace-down;
        "Mod+K".action = focus-workspace-up;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-column-to-workspace-up;
        "Mod+Shift+J".action = move-column-to-workspace-down;

        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
      };
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

      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
    };
  };
}
