{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  niriOff = "niri msg action power-off-monitors";
  niriOn = "niri msg action power-on-monitors";
in {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
      {
        event = "lock";
        command = "lock";
      }
    ];
    #= Timeout in seconds.
    timeouts = [
      {
        timeout = 30 * 60;
        command = niriOff;
        resumeCommand = niriOn;
      }
      {
        timeout = 60 * 60;
        command = getExe pkgs.swaylock;
      }
    ];
    extraArgs = ["-w"];
  };
}
