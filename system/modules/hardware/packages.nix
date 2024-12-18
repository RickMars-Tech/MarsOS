{ pkgs, ... }: {

    environment.systemPackages = with pkgs; [
    #= AMD P-STATE EPP
        #amdctl
    #= ROCm
        #rocmPackages.rocm-core
        #rocmPackages.rocm-runtime 
        #rocmPackages.clr
        #rocmPackages.rocm-smi # Managment interface
        #rocmPackages.rocminfo # ROCm app for reporting System info
        #rocmPackages.rocm-device-libs
    #= Vulkan
        #gfxreconstruct
        #glslang
        #spirv-cross
        #spirv-headers
        #spirv-tools
        #vulkan-extension-layer
        #vulkan-headers
        #vulkan-loader
        #vulkan-tools
        #vulkan-utility-libraries
        #vulkan-validation-layers
        #vulkan-volk
        #vkdisplayinfo
        #vkd3d
        #vkd3d-proton
        #vk-bootstrap
    #= PC monitoring
        stacer # Linux System Optimizer and Monitoring.
        clinfo
        glxinfo
        hardinfo
        hwinfo
        lm_sensors
        # gaming monitoring
        goverlay
        mangohud
        #vkbasalt
    #= Wine
    # support both 32- and 64-bit applications
        wineWowPackages.staging
        samba
    ];
}
