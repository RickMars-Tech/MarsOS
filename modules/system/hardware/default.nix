{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;
in {
  imports = [
    ./asus.nix
    ./audio/default.nix
    ./cpu/default.nix
    ./graphics/default.nix
    ./drives.nix
    ./powerManagement.nix
    ./thinkpad.nix
  ];

  hardware = {
    enableAllFirmware = mkDefault true; # Enable Properitary Firmware
    enableAllHardware = mkDefault true;
    enableRedistributableFirmware = mkForce true; # Lemme update my CPU Microcode, alr?!
    firmware = with pkgs; [
      linux-firmware
    ];
    firmwareCompression = "zstd";
  };
}
