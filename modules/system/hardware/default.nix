{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cpu/default.nix
    ./graphics/default.nix
    ./drives.nix
    ./packages.nix
    ./power-management.nix
    ./thinkpad.nix
  ];

  hardware = {
    enableAllFirmware = lib.mkDefault true; # Enable Properitary Firmware
    enableAllHardware = true;
    enableRedistributableFirmware = lib.mkDefault true; # Lemme update my CPU Microcode, alr?!
    firmware = with pkgs; [
      linux-firmware
    ];
    firmwareCompression = "zstd";
  };
}
