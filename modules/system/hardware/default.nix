{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./asus.nix
    ./cpu/default.nix
    ./graphics/default.nix
    ./drives.nix
    ./packages.nix
    ./pciLatency.nix
    ./powerManagement.nix
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
