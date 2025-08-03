{
  config,
  pkgs,
  lib,
  ...
}: {
  options.mars.thinkpad.enable = lib.mkEnableOption "Thinkpad Twiks";

  config = lib.mkIf (config.mars.thinkpad.enable) {
    boot.kernelModules = [
      "thinkpad-acpi"
    ];

    hardware.trackpoint = {
      enable = lib.mkDefault true;
      emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;
    };

    environment.systemPackages = with pkgs; [
      tpacpi-bat
    ];
  };
}
