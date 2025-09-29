{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  wezterm = lib.getExe pkgs.wezterm;
  color = config.stylix.base16Scheme;
  uwsm = osConfig.programs.uwsm;
in {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "no";
        terminal = "${wezterm}";
        prompt = ">_";
        launch-prefix = mkIf uwsm.enable "uwsm app --";
        icon-theme = "Cosmic";
        # icons-enable = "yes";
        show-actions = "yes";
        anchor = "center";
        layer = "top";
        exit-on-keyboard-focus-loss = "yes";
      };
      border = {
        width = 2;
        radius = 15;
      };
      colors = {
        background = "${color.base00}ff"; #"1e1e2edd";
        text = "${color.base06}ff";
        prompt = "${color.base07}ff";
        placeholder = "${color.base01}ff";
        input = "${color.base0A}ff";
        match = "${color.base0D}ff";
        selection = "${color.base03}ff";
        selection-text = "${color.base07}ff";
        selection-match = "${color.base07}ff";
        counter = "${color.base0C}ff";
        border = "${color.base0B}ff";
      };
    };
  };
}
