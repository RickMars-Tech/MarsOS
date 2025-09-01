{
  config,
  pkgs,
  ...
}: let
  makeCommand = command: {command = [command];};
  wall = config.stylix.image;
in {
  programs.niri.settings.spawn-at-startup = [
    (makeCommand "systemctl --user reset-failed")
    (makeCommand "xwayland-satellite")
    (makeCommand "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2")
    (makeCommand "swww-daemon")
    (makeCommand "swww img ${wall} --transition-type random")
    (makeCommand "$POLKIT_BIN")
    {
      command = [
        "${pkgs.dbus}/bin/dbus-update-activation-environment"
        "--systemd"
        "--all"
      ];
    }
  ];
}
