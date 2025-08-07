{
  config,
  pkgs,
  ...
}: let
  makeCommand = command: {
    command = [command];
  };
  wall = config.stylix.image;
in {
  programs.niri.settings.spawn-at-startup = [
    (makeCommand "systemctl --user import-environment")
    (makeCommand "systemctl --user restart pipewire.service")
    (makeCommand "systemctl --user restart xdg-desktop-portal-gnome.service")
    (makeCommand "systemctl --user restart iwgtk.service")
    # (makeCommand "systemctl --user restart blueman-applet.service")
    (makeCommand "wl-clip-persist --clipboard regular")
    (makeCommand "systemctl --user start cliphist.service")
    (makeCommand "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2")
    (makeCommand "swww-daemon")
    (makeCommand "swww img ${wall}")
    (makeCommand "$POLKIT_BIN")
    (makeCommand "wlr-randr")
    (makeCommand "dunst")
    (makeCommand "qs")
    {
      command = [
        "${pkgs.dbus}/bin/dbus-update-activation-environment"
        "--systemd"
        "DISPLAY"
        "WAYLAND"
        "WAYLAND_DISPLAY"
        "DBUS_SESSION_BUS_ADDRESS"
        "DISPLAY XAUTHORITY"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
        "NIXOS_OZONE_WL"
        "XCURSOR_THEME"
        "XCURSOR_SIZE"
        "XDG_DATA_DIRS"
      ];
    }
  ];
}
