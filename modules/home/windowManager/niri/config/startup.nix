{pkgs, ...}: let
  makeCommand = command: {command = [command];};
in {
  programs.niri.settings.spawn-at-startup = [
    (makeCommand "systemctl --user reset-failed")
    (makeCommand "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2")
    (makeCommand "sway-audio-idle-inhibit")
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
