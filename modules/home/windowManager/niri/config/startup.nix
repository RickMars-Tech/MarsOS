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
    (makeCommand "systemctl --user reset-failed")
    (makeCommand "systemctl --user restart pipewire.service")
    (makeCommand "systemctl --user restart xdg-desktop-portal.service")
    (makeCommand "systemctl --user restart swayidle.service")
    (makeCommand "systemctl --user restart swaync.service")
    (makeCommand "systemctl --user restart ironbar.service")
    (makeCommand "xwayland-satellite")
    (makeCommand "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2")
    (makeCommand "swww-daemon")
    (makeCommand "swww img ${wall} --transition-type random")
    (makeCommand "$POLKIT_BIN")
    (makeCommand "wlr-randr")
    {
      command = [
        "${pkgs.dbus}/bin/dbus-update-activation-environment"
        "--systemd"
        "--all"
        # "DISPLAY"
        # "WAYLAND"
        # "WAYLAND_DISPLAY"
        # "DBUS_SESSION_BUS_ADDRESS"
        # "DISPLAY XAUTHORITY"
        # "XDG_CURRENT_DESKTOP"
        # "XDG_SESSION_TYPE"
        # "NIXOS_OZONE_WL"
        # "XCURSOR_THEME"
        # "XCURSOR_SIZE"
        # "XDG_DATA_DIRS"
      ];
    }
  ];
}
