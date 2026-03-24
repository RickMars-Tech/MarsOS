{
  config,
  lib,
  ...
}: let
  pointer.size = lib.toInt config.environment.sessionVariables.XCURSOR_SIZE;
  pointer.name = config.environment.sessionVariables.XCURSOR_THEME;
in {
  programs.niri.settings = {
    cursor = {
      xcursor-size = pointer.size;
      xcursor-theme = pointer.name;
    };
    layout = {
      background-color = "transparent";

      focus-ring = {
        width = 0.5;
        active-color = "#ffffff";
        inactive-color = "#919191";
        urgent-color = "#ffb4ab";
      };

      shadow = {
        color = "#00000070";
      };

      tab-indicator = {
        active-color = "#ffffff";
        inactive-color = "#919191";
        urgent-color = "#ffb4ab";
      };

      insert-hint = {
        color = "#ffffff80";
      };

      center-focused-column = "on-overflow";
      always-center-single-column = {};

      preset-window-heights._children = [
        {proportion = 1.;}
        {proportion = 1. / 3.;}
        {proportion = 1. / 2.;}
        {proportion = 2. / 3.;}
      ];

      preset-column-widths._children = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];

      default-column-width = {proportion = 1.0 / 2.0;};

      gaps = 4;
      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };
      tab-indicator = {
        hide-when-single-tab = {};
        place-within-column = {};
        position = "left";
        corner-radius = 20.0;
        gap = -12.0;
        gaps-between-tabs = 10.0;
        width = 4.0;
        length._props = {total-proportion = 0.1;};
      };
    };

    recent-windows = {
      highlight = {
        corner-radius = 12;
        active-color = "#d4d4d4";
        urgent-color = "#ffb4ab";
      };
    };

    gestures = {
      dnd-edge-view-scroll = {
        trigger-width = 30;
        delay-ms = 15;
        max-speed = 1500;
      };
      hot-corners.off = {};
    };

    overview = {
      workspace-shadow = {
        off = {};
        # color = "#000000F2";
        # softness = 100;
      };
      zoom = 0.70;
      backdrop-color = "transparent";
    };

    prefer-no-csd = {};
    hotkey-overlay.skip-at-startup = {};
  };
}
