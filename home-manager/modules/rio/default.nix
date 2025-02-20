{config, ...}: let
  cfg-them = config.stylix.base16Scheme;
  cfg-fnt = config.stylix.fonts;
in {
  programs.rio = {
    enable = true;
    settings = {
      fonts = {
        size = 16;
        family = "${cfg-fnt.monospace.name}";
      };
      editor = {
        program = "vi";
      };
      cursor = {
        shape = "beam";
        blinking-interval = 800;
      };
      keyboard = {
        hide-mouse-cursor-when-typing = true;
      };
      navigation = {
        mode = "Bookmark";
      };
      renderer = {
        performance = "High";
        #backend = "Vulkan"; # Mi old T420 dont support Vulkan :C
        disable-unfocused-render = false;
        target-fps = 60;
        strategy = "events";
      };
      window = {
        decorations = "disabled";
        blur = true;
      };

      #==> Custom Theme <==#
      colors = {
        # Regular colors
        background = cfg-them.base00;
        black = cfg-them.base02;
        blue = cfg-them.base0C;
        cursor = cfg-them.base05;
        cyan = cfg-them.base0D;
        foreground = cfg-them.base04;
        green = cfg-them.base0B;
        magenta = cfg-them.base0E;
        red = cfg-them.base08;
        white = cfg-them.base04;
        yellow = cfg-them.base09;

        # Cursor
        vi-cursor = cfg-them.base04;

        # Navigation
        tabs = cfg-them.base05;
        tabs-foreground = cfg-them.base03;
        tabs-active = cfg-them.base02;
        tabs-active-highlight = cfg-them.base09;
        tabs-active-foreground = cfg-them.base05;
        bar = cfg-them.base00;

        # Search
        search-match = {
          background = cfg-them.base0D;
          foreground = cfg-them.base05;
        };

        search-focused-match = {
          background = cfg-them.base09;
          foreground = cfg-them.base05;
        };

        # Selection
        selection = {
          foreground = cfg-them.base04;
          background = cfg-them.base02;
        };

        # Dim colors
        dim = {
          black = cfg-them.base01;
          blue = cfg-them.base03;
          cyan = cfg-them.base03;
          foreground = cfg-them.base03;
          green = cfg-them.base03;
          magenta = cfg-them.base03;
          red = cfg-them.base03;
          white = cfg-them.base03;
          yellow = cfg-them.base03;
        };

        # Light colors
        light = {
          black = cfg-them.base05;
          blue = cfg-them.base07;
          cyan = cfg-them.base07;
          foreground = cfg-them.base05;
          green = cfg-them.base0B;
          magenta = cfg-them.base06;
          red = cfg-them.base08;
          white = cfg-them.base05;
          yellow = cfg-them.base09;
        };
      };
    };
  };
}
