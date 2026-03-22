{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault mkIf;
in {
  options.mars.hardware.thinkpad.enable = mkEnableOption "Thinkpad Configs" // {default = false;};

  config = mkIf (config.mars.hardware.thinkpad.enable) {
    boot.kernelModules = ["thinkpad-acpi"];
    hardware.trackpoint = {
      enable = mkDefault true;
      emulateWheel = mkDefault config.hardware.trackpoint.enable;
    };

    environment.systemPackages = with pkgs; [
      tpacpi-bat
    ];
  };
}
