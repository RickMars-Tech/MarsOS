{
  pkgs,
  lib,
  ...
}: let
  configFile = "ghostty/config";
in {
  environment.systemPackages = with pkgs; [
    ghostty
  ];

  xdg.configFile."${configFile}".text = ''
    ${lib.generators.toKeyValue {
        mkKeyValue = k: v: "${k}=${v}";
        listsAsDuplicateKeys = true;
      } {
        theme = "noctalia";
        gtk-tabs-location = "hidden";
        window-show-tab-bar = "never";

        scrollback-limit = "10000";
        font-family = "FiraCode Nerd Font Propo";
        font-size = "11.0";
        font-feature = "calt,liga,dlig,fina,ss13,ss15";
        cursor-style = "bar";
        cursor-style-blink = "true";
        window-padding-x = "15";
        window-padding-y = "6";
        desktop-notifications = "true";
        resize-overlay = "never";
        window-decoration = "none";
        bell-features = "audio";
        window-inherit-working-directory = "true";
        confirm-close-surface = "false";
        gtk-single-instance = "true";
        quit-after-last-window-closed = "false";
        adjust-cursor-height = "40%";
        adjust-cursor-thickness = "100%";
        adjust-box-thickness = "100%";
        adjust-underline-thickness = "100%";
        adjust-underline-position = "110%";
      }}
    ${lib.concatMapStringsSep "\n" (binding: "keybind=${binding}") [
      "ctrl+shift+i=inspector:toggle"
      "ctrl+shift+p=toggle_command_palette"
      "ctrl+shift+c=copy_to_clipboard"
      "ctrl+shift+v=paste_from_clipboard"
      "ctrl+shift+0=reset_font_size"
      "ctrl+shift+r=reload_config"
      "ctrl++=increase_font_size:1"
      "ctrl+-=decrease_font_size:1"
    ]}
  '';
}
