{
  config,
  pkgs,
  ...
}: let
  fonts = config.stylix.fonts;
in {
  imports = [./theme.nix];
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    extraConfig = ''
      return {
        check_for_updates = false,
        enable_wayland = true,
        enable_tab_bar = false,
        font = wezterm.font("${fonts.monospace.name}"),
        font_size = ${toString fonts.sizes.terminal},
        window_background_opacity = 0.9,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
