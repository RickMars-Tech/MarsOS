{
  flake.modules.nixos.think =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      boot.kernelModules = [ "thinkpad-acpi" ];
      hardware.trackpoint = {
        enable = mkDefault true;
        emulateWheel = mkDefault config.hardware.trackpoint.enable;
      };

      environment.systemPackages = with pkgs; [
        tpacpi-bat
      ];
    };
}
