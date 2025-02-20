{
  config,
  pkgs,
  lib,
  ...
}: {
  #=> OpenGL, Drivers and more...
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libdrm
        mesa.drivers
        #vpl-gpu-rt
      ];
      enable32Bit = true;
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-vaapi-driver
        mesa.drivers
      ];
    };
    intel-gpu-tools.enable = true;
    cpu = {
      x86.msr.enable = true;
      intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
    enableAllFirmware = lib.mkDefault true; # Enable Properitary Firmware
    enableRedistributableFirmware = lib.mkDefault true; # Lemme update my CPU Microcode, alr?!
    firmware = with pkgs; [
      linux-firmware
    ];
    firmwareCompression = "zstd";
  };
}
