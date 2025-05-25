{
  config,
  #inputs,
  pkgs,
  ...
}: let
  cfg = config.stylix;
in {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    #package = inputs.wezterm.packages.${pkgs.system}.default;
    /*
      colorSchemes = {
      "Retro Thinkpad Modern" = {
        # Colores base (mismos que Stylix)
        background = config.stylix.base16Scheme.base00;
        foreground = config.stylix.base16Scheme.base04;

        # ANSI Colors (8 colores básicos)
        ansi = [
          cfg.base16Scheme.base01
          cfg.base16Scheme.base08
          cfg.base16Scheme.base0B
          cfg.base16Scheme.base09
          cfg.base16Scheme.base0D
          cfg.base16Scheme.base0E
          cfg.base16Scheme.base07
          cfg.base16Scheme.base04
        ];

        # Colores brillantes (8 colores adicionales)
        brights = [
          cfg.base16Scheme.base02
          cfg.base16Scheme.base08
          cfg.base16Scheme.base0B
          cfg.base16Scheme.base09
          cfg.base16Scheme.base06
          cfg.base16Scheme.base0E
          cfg.base16Scheme.base07
          cfg.base16Scheme.base02
        ];

        # Colores especiales
        cursor_bg = cfg.base16Scheme.base06;
        cursor_fg = cfg.base16Scheme.base00;
        selection_bg = cfg.base16Scheme.base02;
        selection_fg = cfg.base16Scheme.base04;

        # Colores de la barra de pestañas (opcional)
        tab_bar = {
          background = cfg.base16Scheme.base01;
          active_tab = {
            bg_color = cfg.base16Scheme.base02;
            fg_color = cfg.base16Scheme.base02;
          };
          inactive_tab = {
            bg_color = cfg.base16Scheme.base01;
            fg_color = cfg.base16Scheme.base02;
          };
        };
      };
    };
    */

    extraConfig = ''
      return {
        check_for_updates = false,
        enable_wayland = true,
        font = wezterm.font("${cfg.fonts.monospace.name}"),
        font_size = ${toString cfg.fonts.sizes.terminal},
        window_background_opacity = 0.95,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
