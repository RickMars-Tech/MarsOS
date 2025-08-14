{config, ...}: let
  color = config.lib.stylix.colors;
in {
  programs.wezterm.colorSchemes = {
    "Retro Thinkpad Modern" = {
      # Colores base (mismos que Stylix)
      background = color.base00;
      foreground = color.base04;

      # ANSI Colors (8 colores básicos)
      ansi = [
        color.base00
        color.base08
        color.base0B
        color.base0A
        color.base0D
        color.base0E
        color.base0C
        color.base05
      ];

      # Colores brillantes (8 colores adicionales)
      brights = [
        color.base03
        color.base08
        color.base0B
        color.base0A
        color.base0D
        color.base0E
        color.base0C
        color.base07
      ];

      # Colores especiales
      compose_cursor = color.base06;
      cursor_bg = color.base05;
      cursor_fg = color.base00;
      scrollbar_thumb = color.base01;
      selection_bg = color.base05;
      selection_fg = color.base00;
      split = color.base03;
      visual_bell = color.base09;

      # Colores de la barra de pestañas (opcional)
      tab_bar = {
        background = color.base01;
        inactive_tab_edge = color.base01;
        active_tab = {
          bg_color = color.base00;
          fg_color = color.base05;
        };
        inactive_tab = {
          bg_color = color.base03;
          fg_color = color.base05;
        };
        inactive_tab_hover = {
          bg_color = color.base05;
          fg_color = color.base00;
        };
        new_tab = {
          bg_color = color.base03;
          fg_color = color.base05;
        };
        new_tab_hover = {
          bg_color = color.base05;
          fg_color = color.base00;
        };
      };
    };
  };
}
