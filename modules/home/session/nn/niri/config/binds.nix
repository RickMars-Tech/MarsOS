{ self, ... }:
{
  flake.wrapperModules.niriBinds =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) getExe;
    in
    {
      config.settings =
        let
          asusctl = "${pkgs.asusctl}/bin/asusctl";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          wl-mirror = "${pkgs.wl-mirror}/bin/wl-mirror";
          term = "${getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myWterm}";
          msc = getExe pkgs.mission-center;

          noctalia = getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.noctaliaCore;
          yazi = getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myYazi;
        in
        {
          # Binds
          binds =
            #mkMerge [
            {
              #= Audio
              "XF86AudioPlay".spawn = [
                playerctl
                "play-pause"
              ];
              "XF86AudioStop".spawn = [
                playerctl
                "pause"
              ];
              "XF86AudioPrev".spawn = [
                playerctl
                "previous"
              ];
              "XF86AudioNext".spawn = [
                playerctl
                "next"
              ];

              #= Launch/Spawn Software
              "Mod+T".spawn = [ term ];
              "Mod+E".spawn = [
                term
                "-e"
                yazi
              ];
              "Mod+B".spawn-sh = [ "$BROWSER" ];
              "Mod+Shift+M".spawn-sh = [ msc ];

              #= Mirror Display
              "Mod+P" = _: {
                props.repeat = false;
                content.spawn-sh = [
                  "${wl-mirror} $(niri msg --json focused-output | jq -r .name)"
                ];
              };

              #= Screenshots
              "Print".screenshot = _: { };
              "Ctrl+Print".screenshot-screen = _: { };

              #= Actions
              "Mod+W".toggle-column-tabbed-display = _: { };
              "Mod+Shift+W".toggle-overview = _: { };
              "Mod+Q".close-window = _: { };
              "Mod+S".switch-preset-column-width = _: { };
              "Mod+F".maximize-column = _: { };
              "Mod+Shift+F".fullscreen-window = _: { };
              "Mod+V".toggle-window-floating = _: { };
              "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: { };
              "Mod+Shift+Slash".show-hotkey-overlay = _: { };
              "Mod+Period".expel-window-from-column = _: { };
              "Mod+C".center-column = _: { };

              #= Focus Windows
              "Mod+H".focus-column-left = _: { };
              "Mod+L".focus-column-right = _: { };
              "Mod+K".focus-workspace-up = _: { };
              "Mod+J".focus-workspace-down = _: { };
              "Mod+Left".focus-column-left = _: { };
              "Mod+Right".focus-column-right = _: { };
              "Mod+Down".focus-window-down = _: { };
              "Mod+Up".focus-window-up = _: { };

              #= Move Windows
              "Mod+Shift+H".move-column-left = _: { };
              "Mod+Shift+L".move-column-right = _: { };
              "Mod+Shift+K".move-column-to-workspace-up = _: { };
              "Mod+Shift+J".move-column-to-workspace-down = _: { };
              "Mod+Shift+Ctrl+H".move-column-to-monitor-left = _: { };
              "Mod+Shift+Ctrl+L".move-column-to-monitor-right = _: { };
              "Mod+Shift+Ctrl+K".move-column-to-monitor-up = _: { };
              "Mod+Shift+Ctrl+J".move-column-to-monitor-down = _: { };

              # Noctalia
              "XF86AudioRaiseVolume".spawn = [
                noctalia
                "msg"
                "volume-up"
                "5"
              ];
              "XF86AudioLowerVolume".spawn = [
                noctalia
                "msg"
                "volume-down"
                "5"
              ];
              "XF86AudioMute".spawn = [
                noctalia
                "msg"
                "volume-mute"
              ];
              "XF86MonBrightnessUp".spawn = [
                noctalia
                "msg"
                "brightness-up"
                "5"
              ];
              "XF86MonBrightnessDown".spawn = [
                noctalia
                "msg"
                "brightness-down"
                "5"
              ];
              "Mod+Space".spawn = [
                noctalia
                "msg"
                "panel-toggle"
                "launcher"
              ];
              "Mod+Shift+C".spawn = [
                noctalia
                "msg"
                "panel-toggle"
                "clipboard"
              ];
              "Mod+M".spawn = [
                noctalia
                "msg"
                "panel-toggle"
                "control-center"
                "system"
              ];
              "Mod+Comma".spawn = [
                noctalia
                "msg"
                "panel-toggle"
                "control-center"
              ];
              "Mod+N".spawn = [
                noctalia
                "msg"
                "panel-toggle"
                "control-center"
                "notifications"
              ];
              "Mod+Y".spawn = [
                noctalia
                "msg"
                "panel-toggle"
                "wallpaper"
              ];
              "Mod+X".spawn = [
                noctalia
                "msg"
                "panel-toggle"
                "session"
              ];
              "Mod+Alt+L".spawn = [
                noctalia
                "msg"
                "screen-lock"
              ];

              # Asusctl
              "Mod+Alt+R".spawn = [ "${asusctl} aura effect rainbow-cycle --speed low" ];
              "Mod+Shift+Ctrl+1".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "FF0000"
              ];
              "Mod+Shift+Ctrl+2".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "00FF00"
              ];
              "Mod+Shift+Ctrl+3".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "0000FF"
              ];
              "Mod+Shift+Ctrl+4".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "FFFF00"
              ];
              "Mod+Shift+Ctrl+5".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "FF00FF"
              ];
              "Mod+Shift+Ctrl+6".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "00FFFF"
              ];
              "Mod+Shift+Ctrl+7".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "770066"
              ];
              "Mod+Shift+Ctrl+8".spawn = [
                asusctl
                "aura"
                "effect"
                "static"
                "-c"
                "FFFFFF"
              ];
            };
        };
    };
}
