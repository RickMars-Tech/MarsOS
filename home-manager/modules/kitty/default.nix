{ config, pkgs, lib, ... }: {

    programs.kitty = {
        enable = true;
        font = {
            name = "DaddyTimeMono Nerd Font";
            size = 12;
        };
        shellIntegration.enableFishIntegration = true;
        environment = {
            "TERM" = "kitty";
        };
        settings = {

            # Set Shell Fish
            shell = "fish";

            # Remove close window confirm
            confirm_os_window_close = 0;

            # Transparency
            background_opacity = "0.9";

            # Cursor
            cursor_shape = "beam";
            cursor_blink_interval = 0;
            cursor_stop_blinking_after = 15;

            scrollback_lines = 2000;
            scrollback_pager = "less +G -R";
            wheel_scroll_multiplier = 5;
            click_interval = 1;
            mouse_hide_wait = 0;


            select_by_word_characters = ":@-./_~?&=%+#";
            enabled_layouts = "*";

            # Window
            remember_window_size = false;
            initial_window_width = 1200;
            initial_window_height = 900;
            window_border_width = 0;
            window_margin_width = 15;

            # Keyboard to screen latency
            repaint_delay = 3;
            input_delay = 0;
            sync_to_monitor = "no";
            wayland_enable_ime = "no";

            # Wayland
            linux_display_server = "wayland";
            hide_window_decorations = "yes";
            wayland_titlebar_color = "background";
            macos_option_as_alt = "no";

            visual_bell_duration = 0;
            enable_audio_bell = "no";

            # Custom Theme
            background = "#" + "0E0E17";
            foreground = "#" + "c4c5e6";
            cursor = "#" + "c4c5e6";
            selection_background = "#" + "0E0E17";
            color0 = "#" + "9c9db8";
            color8 = "#" + "9c9db8";
            color1 = "#" + "94594B";
            color9 = "#" + "94594B";
            color2 = "#" + "C69E5B";
            color10 = "#" + "C69E5B";
            color3 = "#" + "5F5B9D";
            color11 = "#" + "5F5B9D";
            color4 = "#" + "445CAD";
            color12 = "#" + "445CAD";
            color5 = "#" + "8D6FAE";
            color13 = "#" + "8D6FAE";
            color6 = "#" + "5E95DD";
            color14 = "#" + "5E95DD";
            color7 = "#" + "c4c5e6";
            color15 = "#" + "c4c5e6";
            selection_foreground = "#" + "0B0C17";

        };
        keybindings = {
            # Clipboard
            "ctrl+shift+v" = "paste_from_clipboard";
            "ctrl+shift+s" = "paste_from_selection";
            "ctrl+shift+c" = "copy_to_clipboard";
            "shift+insert" = "paste_from_selection";

            # Tab management
            "ctrl+shift+right" = "next_tab";
            "ctrl+shift+left" = "previous_tab";
            "ctrl+shift+t" = "new_tab";
            "ctrl+shift+q" = "close_tab";
            "ctrl+shift+l" = "next_layout";
            "ctrl+shift+." = "move_tab_forward";
            "ctrl+shift+," = "move_tab_backward";

            # Miscellaneous
            "ctrl+shift+up" = "increase_font_size";
            "ctrl+shift+down" = "decrease_font_size";
            "ctrl+shift+backspace" = "restore_font_size";
        };

        #theme = "Wizzy Muted"; #"Black Metal"; # "Argonaut"; #"Floraverse";
    };

}
