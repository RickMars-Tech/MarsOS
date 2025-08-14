{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./cpu/default.nix
    ./graphics/default.nix
    ./drives.nix
    ./packages.nix
    ./power-management.nix
    ./thinkpad.nix
  ];

  hardware = {
    enableAllFirmware = mkDefault true; # Enable Properitary Firmware
    enableAllHardware = true;
    enableRedistributableFirmware = mkDefault true; # Lemme update my CPU Microcode, alr?!
    firmware = with pkgs; [
      linux-firmware
    ];
    firmwareCompression = "zstd";
  };
}
