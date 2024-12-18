{ config, pkgs, lib, ... }: {

#=> OpenGL, Drivers and more... 

    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };

    hardware = {
        graphics = {
            enable = true;
            extraPackages = with pkgs; [
                intel-vaapi-driver
                libdrm
                mesa.drivers
            ];
            enable32Bit = true;
            extraPackages32 = with pkgs.driversi686Linux; [
                intel-vaapi-driver
                mesa.drivers
                vaapiIntel
                vaapiVdpau
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
    };

}
