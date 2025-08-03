{config, ...}: let
  cfg = config.stylix.base16Scheme;
in {
  programs.wezterm.colorSchemes = {
    "Retro Thinkpad Modern" = {
      # Colores base (mismos que Stylix)
      background = cfg.base00;
      foreground = cfg.base04;

      # ANSI Colors (8 colores básicos)
      ansi = [
        cfg.base00
        cfg.base08
        cfg.base0B
        cfg.base0A
        cfg.base0D
        cfg.base0E
        cfg.base0C
        cfg.base05
      ];

      # Colores brillantes (8 colores adicionales)
      brights = [
        cfg.base03
        cfg.base08
        cfg.base0B
        cfg.base0A
        cfg.base0D
        cfg.base0E
        cfg.base0C
        cfg.base07
      ];

      # Colores especiales
      compose_cursor = cfg.base06;
      cursor_bg = cfg.base05;
      cursor_fg = cfg.base00;
      scrollbar_thumb = cfg.base01;
      selection_bg = cfg.base05;
      selection_fg = cfg.base00;
      split = cfg.base03;
      visual_bell = cfg.base09;

      # Colores de la barra de pestañas (opcional)
      tab_bar = {
        background = cfg.base01;
        inactive_tab_edge = cfg.base01;
        active_tab = {
          bg_color = cfg.base00;
          fg_color = cfg.base05;
        };
        inactive_tab = {
          bg_color = cfg.base03;
          fg_color = cfg.base05;
        };
        inactive_tab_hover = {
          bg_color = cfg.base05;
          fg_color = cfg.base00;
        };
        new_tab = {
          bg_color = cfg.base03;
          fg_color = cfg.base05;
        };
        new_tab_hover = {
          bg_color = cfg.base05;
          fg_color = cfg.base00;
        };
      };
    };
  };
}
