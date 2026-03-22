{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkMerge mkIf;
  asus = config.mars.hardware.asus;
  asusctl = "${pkgs.asusctl}/bin/asusctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  term = getExe pkgs.wezterm; #getExe pkgs.ghostty;
  nsh = config.programs.noctalia-shell;
  msc = getExe pkgs.mission-center;
in {
  programs.niri.settings.binds = mkMerge [
    {
      #= Audio
      "XF86AudioPlay".spawn = [playerctl "play-pause"];
      "XF86AudioStop".spawn = [playerctl "pause"];
      "XF86AudioPrev".spawn = [playerctl "previous"];
      "XF86AudioNext".spawn = [playerctl "next"];
      #= Launch/Spawn Software
      "Mod+T".spawn = [term]; #"+new-window"];
      "Mod+E".spawn = [term "-e" "yazi"];
      "Mod+B".spawn = ["firefox"];
      "Mod+Shift+M".spawn = [msc];
      #= Screenshots
      "Print".screenshot = {};
      "Ctrl+Print".screenshot-screen = {};
      #= Actions
      "Mod+W".toggle-column-tabbed-display = {};
      "Mod+Shift+W".toggle-overview = {};
      "Mod+Q".close-window = {};
      "Mod+S".switch-preset-column-width = {};
      "Mod+F".maximize-column = {};
      "Mod+Shift+F".fullscreen-window = {};
      "Mod+V".toggle-window-floating = {};
      "Mod+Shift+V".switch-focus-between-floating-and-tiling = {};
      "Mod+Shift+Slash".show-hotkey-overlay = {};
      "Mod+Period".expel-window-from-column = {};
      "Mod+C".center-column = {};
      #= Focus Windows
      "Mod+H".focus-column-left = {};
      "Mod+L".focus-column-right = {};
      "Mod+K".focus-workspace-up = {};
      "Mod+J".focus-workspace-down = {};
      "Mod+Left".focus-column-left = {};
      "Mod+Right".focus-column-right = {};
      "Mod+Down".focus-window-down = {};
      "Mod+Up".focus-window-up = {};
      #= Move Windows
      "Mod+Shift+H".move-column-left = {};
      "Mod+Shift+L".move-column-right = {};
      "Mod+Shift+K".move-column-to-workspace-up = {};
      "Mod+Shift+J".move-column-to-workspace-down = {};
      "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
      "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};
      "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
      "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
    }
    (mkIf asus.enable {
      "Mod+Alt+R".spawn = ["${asusctl} aura effect rainbow-cycle --speed low"];
      "Mod+Shift+Ctrl+1".spawn = [asusctl "aura" "effect" "static" "-c" "FF0000"];
      "Mod+Shift+Ctrl+2".spawn = [asusctl "aura" "effect" "static" "-c" "00FF00"];
      "Mod+Shift+Ctrl+3".spawn = [asusctl "aura" "effect" "static" "-c" "0000FF"];
      "Mod+Shift+Ctrl+4".spawn = [asusctl "aura" "effect" "static" "-c" "FFFF00"];
      "Mod+Shift+Ctrl+5".spawn = [asusctl "aura" "effect" "static" "-c" "FF00FF"];
      "Mod+Shift+Ctrl+6".spawn = [asusctl "aura" "effect" "static" "-c" "00FFFF"];
      "Mod+Shift+Ctrl+7".spawn = [asusctl "aura" "effect" "static" "-c" "770066"];
      "Mod+Shift+Ctrl+8".spawn = [asusctl "aura" "effect" "static" "-c" "FFFFFF"];
    })
    (mkIf nsh.enable {
      "Mod+Space" = {
        _props.hotkey-overlay-title = "Application Launcher";
        spawn = ["noctalia-shell" "ipc" "call" "launcher" "toggle"];
      };
      "Mod+Shift+C" = {
        _props.hotkey-overlay-title = "Clipboard Manager";
        spawn = ["noctalia-shell" "ipc" "call" "launcher" "clipboard"];
      };
      "Mod+M" = {
        _props.hotkey-overlay-title = "Task Manager";
        spawn = ["noctalia-shell" "ipc" "call" "systemMonitor" "toggle"];
      };
      "Mod+Comma" = {
        _props.hotkey-overlay-title = "Settings";
        spawn = ["noctalia-shell" "ipc" "call" "settings" "toggle"];
      };
      "Mod+N" = {
        _props.hotkey-overlay-title = "Notification Center";
        spawn = ["noctalia-shell" "ipc" "call" "notifications" "toggleHistory"];
      };
      "Mod+Y" = {
        _props.hotkey-overlay-title = "Browse Wallpapers";
        spawn = ["noctalia-shell" "ipc" "call" "wallpaper" "toggle"];
      };
      "Mod+X" = {
        _props.hotkey-overlay-title = "Power Menu";
        spawn = ["noctalia-shell" "ipc" "call" "sessionMenu" "toggle"];
      };
      "Mod+Alt+L" = {
        _props.hotkey-overlay-title = "Lock Screen";
        spawn = ["noctalia-shell" "ipc" "call" "lockScreen" "lock"];
      };
      "XF86AudioRaiseVolume" = {
        _props.allow-when-locked = true;
        spawn = ["noctalia-shell" "ipc" "call" "volume" "increase"];
      };
      "XF86AudioLowerVolume" = {
        _props.allow-when-locked = true;
        spawn = ["noctalia-shell" "ipc" "call" "volume" "decrease"];
      };
      "XF86AudioMute" = {
        _props.allow-when-locked = true;
        spawn = ["noctalia-shell" "ipc" "call" "volume" "muteOutput"];
      };
      "XF86MonBrightnessUp" = {
        _props.allow-when-locked = true;
        spawn = ["noctalia-shell" "ipc" "call" "brightness" "increase"];
      };
      "XF86MonBrightnessDown" = {
        _props.allow-when-locked = true;
        spawn = ["noctalia-shell" "ipc" "call" "brightness" "decrease"];
      };
    })
  ];
}
