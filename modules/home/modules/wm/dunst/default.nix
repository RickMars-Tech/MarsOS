{config, ...}: let
  icon-pkg = config.stylix.iconTheme.package;
  icon-name = config.stylix.iconTheme.dark;
in {
  services.dunst = {
    enable = true;
    iconTheme = {
      package = icon-pkg; #pkgs.cosmic-icons; #pkgs.flat-remix-icon-theme;
      name = icon-name; #"Cosmic"; #"Flat-Remix-Blue-Dark";
    };
    settings = {
      global = {
        #frame_color = "#89b4fa";
        #separator_color = "frame";
        markup = "full";
        format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action";
        mouse_right_click = "close_all";
      };

      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };

      urgency_low = {
        timeout = 10;
      };

      urgency_normal = {
        timeout = 10;
      };

      urgency_critical = {
        timeout = 0;
      };
    };
  };
}
