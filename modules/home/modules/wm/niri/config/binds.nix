{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "XF86AudioMute".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
    "XF86AudioMicMute".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
    "XF86AudioRaiseVolume".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
    "XF86AudioLowerVolume".action.spawn = ["${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];

    "XF86AudioPlay".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
    "XF86AudioStop".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "pause"];
    "XF86AudioPrev".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "previous"];
    "XF86AudioNext".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "next"];

    "Mod+T".action.spawn = ["${pkgs.ghostty}/bin/ghostty"];
    "Mod+E".action.spawn = ["${pkgs.ghostty}/bin/ghostty" "-e" "yazi"];
    "Mod+B".action.spawn = ["${lib.getExe pkgs.firefox}"];
    "Mod+R".action.spawn = ["${lib.getExe pkgs.fuzzel}"];
    "Mod+Shift+Q".action.spawn = ["${lib.getExe pkgs.hyprlock}"];
    "Mod+Shift+M".action.spawn = ["${lib.getExe pkgs.wlogout}"];

    "Print".action = screenshot;

    "Mod+W".action = toggle-column-tabbed-display;
    "Mod+Shift+W".action = toggle-overview;
    "Mod+Q".action = close-window;
    "Mod+S".action = switch-preset-column-width;
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+V".action = toggle-window-floating;
    "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

    "Mod+Shift+Slash".action = show-hotkey-overlay;

    "Mod+Comma".action = consume-window-into-column;
    "Mod+Period".action = expel-window-from-column;
    "Mod+C".action = center-column;

    #= Focus Windows
    "Mod+H".action = focus-column-left;
    "Mod+L".action = focus-column-right;
    "Mod+K".action = focus-workspace-down;
    "Mod+J".action = focus-workspace-up;
    "Mod+Left".action = focus-column-left;
    "Mod+Right".action = focus-column-right;
    "Mod+Down".action = focus-window-down;
    "Mod+Up".action = focus-window-up;

    #= Move Windows
    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+L".action = move-column-right;
    "Mod+Shift+J".action = move-column-to-workspace-up;
    "Mod+Shift+K".action = move-column-to-workspace-down;

    "Mod+Shift+Ctrl+K".action = move-column-to-monitor-down;
    "Mod+Shift+Ctrl+J".action = move-column-to-monitor-up;
  };
}
