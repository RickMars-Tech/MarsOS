{pkgs, ...}: {
  environment.systemPackages = [pkgs.wezterm];

  xdg.configFile."wezterm/wezterm.lua" = {
    mutable = true;
    text = ''
      local wezterm = require 'wezterm'
      return {
        check_for_updates = false,
        enable_wayland = true,
        enable_tab_bar = false,
        font = wezterm.font("FiraCode Nerd Font Propo"),
        font_size = 11,
        color_scheme = "Noctalia",
        window_background_opacity = 1.0,
        hide_tab_bar_if_only_one_tab = true,
        audible_bell = "Disabled",
      }
    '';
  };
}
