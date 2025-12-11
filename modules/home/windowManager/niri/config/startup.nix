{pkgs, ...}: {
  programs.niri.settings.spawn-at-startup = [
    {sh = "systemctl --user reset-failed";}
    {sh = "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2";}
    {sh = "sway-audio-idle-inhibit";}
    {sh = "$POLKIT_BIN";}
    {sh = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all";}
  ];
}
