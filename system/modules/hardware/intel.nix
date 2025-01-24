{ config, pkgs, lib, ... }: {

#=> OpenGL, Drivers and more... 

    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    hardware = {
        graphics = {
            enable = true;
            extraPackages = with pkgs; [
                intel-vaapi-driver
                libdrm
                libvdpau-va-gl
                mesa.drivers
                vpl-gpu-rt
            ];
            enable32Bit = true;
            extraPackages32 = with pkgs.driversi686Linux; [
                intel-vaapi-driver
                mesa.drivers
                libvdpau-va-gl
            ];
        };
        intel-gpu-tools.enable = true;
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        enableAllFirmware = lib.mkDefault true; # Enable Properitary Firmware
        enableRedistributableFirmware = lib.mkDefault true; # Lemme update my CPU Microcode, alr?!
        firmware = with pkgs; [
            linux-firmware
        ];
        firmwareCompression = "zstd";
    };

}
