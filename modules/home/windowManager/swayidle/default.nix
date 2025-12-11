{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  minutes = 60;
  lockCmd = "${pkgs.systemd}/bin/loginctl lock-session";
  niriOff = "${pkgs.niri}/bin/niri msg action power-off-monitors";
  niriOn = "${pkgs.niri}/bin/niri msg action power-on-monitors";
  hyprlockCmd = getExe pkgs.hyprlock;
in {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "lock";
        command = hyprlockCmd;
      }
    ];
    timeouts = [
      {
        timeout = 12 * minutes;
        command = niriOff;
        resumeCommand = niriOn;
      }
      {
        timeout = 15 * minutes;
        command = lockCmd;
      }
    ];
    extraArgs = ["-w"];
  };
}
