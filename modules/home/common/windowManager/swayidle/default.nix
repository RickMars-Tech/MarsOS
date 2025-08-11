{
  pkgs,
  lib,
  ...
}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = lib.getExe pkgs.hyprlock;
      }
      {
        event = "lock";
        command = "lock";
      }
    ];
    #= Timeout in seconds.
    timeouts = [
      {
        timeout = 2700;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight";
      }
      {
        timeout = 3000;
        command = lib.getExe pkgs.hyprlock;
      }
      {
        timeout = 3000;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    extraArgs = ["-w"];
  };
}
