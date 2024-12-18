{ pkgs, ... }: 

{

#=> OpenGL, Drivers and more... 
    hardware = {
        graphics = {
            enable = true;
            extraPackages = with pkgs; [
                mesa.drivers
                libdrm
                vdpauinfo
                libva-vdpau-driver
                libvdpau-va-gl
            ];
            enable32Bit = true;
            extraPackages32 = with pkgs.driversi686Linux; [
                mesa.drivers
                #glxinfo
                vdpauinfo
                libva-vdpau-driver
                libvdpau-va-gl
            ];
        };
        amdgpu = {
            opencl.enable = true; # enable OpenCL using ROCM runtime library.
            legacySupport.enable = true; # Enable for using amdgpu kernel driver instead of radeon.
            initrd.enable = true;
        };
    };

#=> Hardware & Firmware
    hardware = {
        cpu = {
            x86.msr.enable = true; #= MSR (Model-Specific Registers).
            amd.updateMicrocode = true; # Update Microcode
        };
        enableAllFirmware = true; # Enable Properitary Firmware
        enableRedistributableFirmware = true; # Lemme update my CPU Microcode, alr?!
        firmware = with pkgs; [
            linux-firmware
        ];
    };

}
