{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkMerge mkIf;
  asus = osConfig.mars.asus;
  asusctl = "${pkgs.asusctl}/bin/asusctl";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  launcher = getExe pkgs.walker;
  firefox = getExe pkgs.firefox;
  term = getExe pkgs.wezterm;
  lock = getExe pkgs.hyprlock;
  logout = getExe pkgs.wlogout;
in {
  programs.niri.settings.binds = with config.lib.niri.actions;
    mkMerge [
      {
        #= Audio
        "XF86AudioMute".action.spawn = [wpctl "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        "XF86AudioMicMute".action.spawn = [wpctl "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        "XF86AudioRaiseVolume".action.spawn = [wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
        "XF86AudioLowerVolume".action.spawn = [wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];

        "XF86AudioPlay".action.spawn = [playerctl "play-pause"];
        "XF86AudioStop".action.spawn = [playerctl "pause"];
        "XF86AudioPrev".action.spawn = [playerctl "previous"];
        "XF86AudioNext".action.spawn = [playerctl "next"];

        #= Launch/Spawn Software
        "Mod+T".action.spawn = [term];
        "Mod+E".action.spawn = [term "-e" "yazi"];
        "Mod+B".action.spawn = [firefox];
        "Mod+R".action.spawn = [launcher];
        "Mod+Shift+Q".action.spawn = [lock];
        "Mod+Shift+M".action.spawn = [logout];

        #= Screenshots
        "Print".action.screenshot.show-pointer = true;
        "Ctrl+Print".action.screenshot-window.write-to-disk = true;

        #= Actions
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

        #= Screen Mirror (Test) # wl-present mirror eDP-1 --fullscreen-output HDMI-A-1 --fullscreen
        #"Mod+Shift+M".action.spawn = ["wl-present" "mirror" "eDP-1" "--fullscreen-output" "HDMI-A-1" "--fullscreen"];

        #= Focus Windows
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-workspace-up;
        "Mod+J".action = focus-workspace-down;

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;

        #= Move Windows
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-column-to-workspace-up;
        "Mod+Shift+J".action = move-column-to-workspace-down;

        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
      }
      #= Asusctl Aura/RGB Control
      (mkIf asus.enable {
        # Rainbow Modes
        "Mod+Alt+R".action.spawn = [asusctl "aura" "rainbow-cycle"];

        # Quick Color Modes
        "Mod+Shift+Ctrl+G".action.spawn = [asusctl "aura" "static" "-c" "FF0000"]; # Gaming (Red)
        "Mod+Shift+Ctrl+W".action.spawn = [asusctl "aura" "breathe" "-c" "4169E1"]; # Work (Blue breathe)
        "Mod+Shift+Ctrl+P".action.spawn = [asusctl "aura" "pulse" "-c" "FF0000"]; # Pulse (Red)

        # Breathe mode with different colors
        "Mod+Shift+Ctrl+B".action.spawn = [asusctl "aura" "breathe" "-c" "770066"]; # Purple breathe

        # Quick Static Colors
        "Mod+Shift+Ctrl+1".action.spawn = [asusctl "aura" "static" "-c" "FF0000"]; # Red
        "Mod+Shift+Ctrl+2".action.spawn = [asusctl "aura" "static" "-c" "00FF00"]; # Green
        "Mod+Shift+Ctrl+3".action.spawn = [asusctl "aura" "static" "-c" "0000FF"]; # Blue
        "Mod+Shift+Ctrl+4".action.spawn = [asusctl "aura" "static" "-c" "FFFF00"]; # Yellow
        "Mod+Shift+Ctrl+5".action.spawn = [asusctl "aura" "static" "-c" "FF00FF"]; # Magenta
        "Mod+Shift+Ctrl+6".action.spawn = [asusctl "aura" "static" "-c" "00FFFF"]; # Cyan
        "Mod+Shift+Ctrl+7".action.spawn = [asusctl "aura" "static" "-c" "770066"]; # Purple
        "Mod+Shift+Ctrl+8".action.spawn = [asusctl "aura" "static" "-c" "FF6600"]; # Orange
      })
    ];
}
