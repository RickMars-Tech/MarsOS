{ config, pkgs, ... }: let

    cfg = config.home;

in {

    imports = [
        ./hypridle.nix
        ./hyprlock.nix
        ./hyprpaper.nix
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        settings = {

            monitor = [
                #", preferred, auto, 1"
                ", highres, auto, 1"
            ];

            env = [
                #= Hyprland
                "XDG_CURRENT_DESKTOP, Hyprland"
                "XDG_SESSION_TYPE, wayland"
                "XDG_SESSION_DESKTOP, Hyprland"
                "HYPRLAND_TRACE, 0"
                "HYPRLAND_NO_RT, 0"
                "HYPRLAND_NO_SD_NOTIFY, 1"
                #= Toolkit Backend Variables 
                "GDK_BACKEND,wayland,x11,*"
                "QT_QPA_PLATFORM,wayland;xcb"
                "SDL_VIDEODRIVER,wayland"
                "CLUTTER_BACKEND,wayland"
                #= XWayland
                "GDK_SCALE, 1"
                "XCURSOR_SIZE, 24"
                #= Qt
                "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
                "QT_QPA_PLATFORM, wayland;xcb"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
                #= Hyprcursor
                "HYPRCURSOR_THEME,${cfg.pointerCursor.name}"
                "HYPRCURSOR_SIZE,${toString cfg.pointerCursor.size}"
            ];

            exec-once = [
                "dbus-update-activation-environment --systemd --all WAYLAND DISPLAY XDG_CURRENT_DESKTOP"
                "systemctl --user restart pipewire # Restart pipewire to avoid bugs"
                "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"
                "wl-clipboard-history -t"
                "wl-paste --type text --watch cliphist store"
                "wl-paste --type image --watch cliphist store"
                "$POLKIT_BIN"
                "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
            ];

            xwayland = {
                use_nearest_neighbor = true;
                force_zero_scaling = true;
            };

            opengl = {
                force_introspection = 1;
            };

            render = {
                explicit_sync = 1;
                explicit_sync_kms = 1;
                direct_scanout = true;
            };

            cursor = {
                no_hardware_cursors = true;
                no_break_fs_vrr = true;
                min_refresh_rate = 60;
                persistent_warps = true;
                warp_on_change_workspace = true;
                enable_hyprcursor = true;
                hide_on_key_press = false;
            };

            input = {
                kb_model = ""; #"pc104";
                kb_layout = "us"; #"latam";
                kb_variant = "";
                kb_options = ""; #"terminate:ctrl_alt_bksp";
                numlock_by_default = true;
                accel_profile = "flat";
                follow_mouse = 1;
                sensitivity = 0;
                float_switch_override_focus = 2;
                touchpad = {
                    disable_while_typing = 0;
                    natural_scroll = 0;
                    clickfinger_behavior = 0;
                    tap-to-click = 1;
                    drag_lock = 0;
                };
            };

            general = {
                "$mainMod" = "SUPER";
                layout = "master"; #"dwindle";
                gaps_in = 2;
                gaps_out = 4;
                border_size = 2;
                "col.active_border" = "rgba(fe5ff7ee) rgba(33ccffee) 45deg "; #rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)"; #"0xff444444";
                border_part_of_window = false;
                no_border_on_floating = false;
            };

            dwindle = {
                no_gaps_when_only = 0;
                force_split = 0;
                special_scale_factor = 1.0;
                split_width_multiplier = 1.0;
                use_active_for_splits = true;
                pseudotile = true;
                preserve_split = true;
            };

            master = {
                allow_small_split = true;
                new_status = "slave";
                new_on_top = true;
                inherit_fullscreen = true;
                always_center_master = true;
                drop_at_cursor = true;
            };

            misc = {
                disable_hyprland_logo = true;
                mouse_move_enables_dpms = true;
                animate_manual_resizes = true;
                swallow_regex = "^(foot|kitty|Alacritty)$";
                swallow_exception_regex = "^(foot|kitty|Alacritty)";
                vrr = 0; # VRR (Adaptive Sync). 0 - Disabled, 1 - Enabled, 2 - Only FullScreen
                vfr = true;
                render_ahead_safezone = 1;
                new_window_takes_over_fullscreen = 2;
            };

            decoration = {
                rounding = 7;

                blur = {
                    enabled = false;
                    size = 3;
                    passes = 1;
                    new_optimizations = true;
                };

                drop_shadow = false;

                shadow_ignore_window = true;
                shadow_offset = "0 2";
                shadow_range = 10;
                shadow_render_power = 2;
                "col.shadow" = "rgba(00000055)";
            };

            animations = {
                enabled = true;
                first_launch_animation = true;
                bezier = [
                    #"myBezier, 0.05, 0.9, 0.1, 1.05"
                    "fluent_decel, 0, 0.2, 0.4, 1"
                    "easeOutCirc, 0, 0.55, 0.45, 1"
                    "easeOutCubic, 0.33, 1, 0.68, 1"
                    "easeinoutsine, 0.37, 0, 0.63, 1"
                ];
                animation = [
                        #"windows, 1, 7, myBezier"
                        #"windowsOut, 1, 7, default, popin 80%"
                        #"border, 1, 10, default"
                        #"borderangle, 1, 8, default"
                        #"fade, 1, 7, default"
                        #"workspaces, 1, 3, default"
                        
                        # Windows
                        "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
                        "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
                        "windowsMove, 1, 2, easeinoutsine, slide" # everything in between, moving, dragging, resizing.

                        # Fade
                        "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
                        "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
                        "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
                        "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
                        "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
                        "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
                        "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
                        "workspaces, 1, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
                ];
               
            };

            gestures = {
                workspace_swipe = true;
                workspace_swipe_fingers = 3;
                workspace_swipe_min_speed_to_force = 0;
                workspace_swipe_forever = true;
                workspace_swipe_use_r = false;
            };

            binds = {
                allow_workspace_cycles = true;
            };

            bind = [
                # Screenshot
                ", Print, exec, grimblast --notify copysave output"
                "SHIFT, Print, exec, grimblast --notify --cursor copysave area"

                # Gamemode
                #"SUPER, F1, exec, ~/.config/hypr/scripts/gamemode.sh"

                #''Alt+n, "type ñ"''
                #''Alt+N, "type Ñ"''


                # LaunchApps
                #"SUPER, T, exec, kitty"
                "SUPER, Z, exec, zeditor"
                "SUPER, T, exec, foot"
                "SUPER, B, exec, firefox"
                "CTRL SHIFT, E, exec, nautilus"
                #"SUPER, E, exec, kitty -e yazi"
                "SUPER, E, exec, foot -e yazi"
                "SUPER, S, swapsplit, # dwindle"
                "SUPER, R, exec, pkill rofi || rofi -show drun -show-icons"
                "SUPER SHIFT, H, exec, hyprpicker -r -a"

                # Brightnes
                ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
                ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"

                # Windows
                "SUPER, S, swapnext,"
                "SUPER, V, togglefloating"

                "SUPER, F, fullscreen"

                "SUPER, left, movefocus, l"
                "SUPER, right, movefocus, r"
                "SUPER, up, movefocus, u"
                "SUPER, down, movefocus, d"

                # Close Windows
                "SUPER, Q, killactive,"

                # Lock System
                "SUPER, L, exec, hyprlock"

                # Off
                "SUPER, M, exec, wlogout"

                "SUPER, mouse_down, workspace, e+1"
                "SUPER, mouse_up, workspace, e-1"
                "SUPER, 1, workspace,1"
                "SUPER, 2, workspace,2"
                "SUPER, 3, workspace,3"
                "SUPER, 4, workspace,4"
                "SUPER, 5, workspace,5"
                "SUPER, 6, workspace,6"
                "SUPER, 7, workspace,7"
                "SUPER, 8, workspace,8"
                "SUPER, 9, workspace,9"
                "SUPER, 0, workspace,10"

                "ALT, 1, movetoworkspace,1"
                "ALT, 2, movetoworkspace,2"
                "ALT, 3, movetoworkspace,3"
                "ALT, 4, movetoworkspace,4"
                "ALT, 5, movetoworkspace,5"
                "ALT, 6, movetoworkspace,6"
                "ALT, 7, movetoworkspace,7"
                "ALT, 8, movetoworkspace,8"
                "ALT, 9, movetoworkspace,9"
                "ALT, 0, movetoworkspace,10"
            ];

            bindm = [
                # Manage Workspaces
                "SUPER, mouse:272, movewindow"
                "SUPER, Control_L, movewindow"
                "SUPER, mouse:273, resizewindow"
            ];

            bindl = [
                # You can view your switches in hyprctl devices.
                ",switch:Lid Switch,exec,${pkgs.hyprlock}/bin/hyprlock"
                #",switch:on:Lid Switch,exec,hyprctl keyword monitor '', disable''"
                #",switch:off:Lid Switch,exec,hyprctl keyword monitor '',highres,auto,1''"

                # Audio
                ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

                # Multimedia
                ",XF86AudioPlay, exec, playerctl play-pause"
                ",XF86AudioPause, exec, playerctl play-pause"
            ];

            windowrulev2 = [
                # QBittorrent
                "float,class:^(org.qbittorrent.qBittorrent)$"

                # Disk/Files
                "float, class:^(org.gnome.Nautilus)$"
                "float, class:^(org.gnome.baobab)$"
                "float, class:^(gnome-disks)$"

                # IWGTK
                "float,title:^(iwgtk)$"
                "float,class:^(iwgtk)$"
                "float,class:^(org.twosheds.iwgtk)$"
                
                # Pipewire (Pwvucontrol).
                "float,title:^(Pipewire Volume Control)$"

                # PulseAudio (Pavucontrol).
                "float,class:^(pavucontrol)$"

                # Firefox
                "float, title:^(Library)$,class:^(firefox)$"
                "float,title:^(Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox)$,class:^(firefox)$"
                "nomaxsize,title:^(Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox)$,class:^(firefox)$"

                # Waydroid
                "float, class:^(Waydroid)$"

                # Steam
                "stayfocused, title:^()$,class:^(steam)$"
                "minsize 1 1, title:^()$,class:^(steam)$"
                "noblur, class:^(steam)$"
                "forcergbx,class:^(steam)$"
                "float, title:^(Configuraciones de Steam)$"
                "nomaxsize, class:^(net.davidotek.pupgui2)$"
                "float, class:^(net.davidotek.pupgui2)$"
                "float, class:^(steamwebhelper)$"

                "float,title:^(ProtonUp-Qt)$"

                # Foot+Zellij
                #"size 950 550, class:^(foot)$"
                #"float, class: ^(foot)$"

                # Lutris
                "float,class:^(lutris)$"

                # Workspaces
                "workspace 1, class: ^(kitty)$"
                "workspace 1, class: ^(foot)$"
                "workspace 2 silent, class: ^(steam)$"
                "workspace 2 silent, class: ^(Lutris)$"
                "workspace 3, class: ^(firefox)$"
                "workspace 3, class: ^(floorp)$"
                "workspace 4, class: ^(WebCord)$"
                "workspace 5, class: ^(mpv)$"
                "workspace 6, class: ^(imv)$"
                "workspace 7, class: ^(org.gnome.Nautilus)$"
                "workspace 8, class: ^(gnome-disks)$"
                "workspace 9 silent, title: ^(Waydroid)$"

                "idleinhibit focus,class:^(mpv)$"
                "idleinhibit fullscreen,class:^(Firefox)$"

                # xwaylandvideobridge
                "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
                "noanim,class:^(xwaylandvideobridge)$"
                "noinitialfocus,class:^(xwaylandvideobridge)$"
                "maxsize 1 1,class:^(xwaylandvideobridge)$"
                "noblur,class:^(xwaylandvideobridge)$"
            ];

        };
        #extraConfig = ''
        #    monitor = , highres, auto, 1
        #'';
    };

    xdg.configFile = {
        "hypr/xdph.conf".source = ./xdph.conf;
    };

}
