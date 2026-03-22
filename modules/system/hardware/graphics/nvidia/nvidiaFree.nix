{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  nouveau = config.mars.hardware.graphics.nvidiaFree;
  nvidiaPro = config.mars.hardware.graphics.nvidiaPro;
  gaming = config.mars.gaming.gamemode;
in {
  options.mars.hardware.graphics.nvidiaFree = {
    enable = mkEnableOption "Enable Free nVidia graphics Nouveau" // {default = !nvidiaPro.enable;};
    # vulkan = mkEnableOption "Vulkan Support via NVK" // {default = true;};
    # opengl = mkEnableOption "OpenGL Support" // {default = true;};
    zink = mkEnableOption "Enable Zink OpenGL-on-Vulkan" // {default = false;};
    acceleration = {
      vaapi = mkEnableOption "VAAPI video acceleration" // {default = true;};
      vdpau = mkEnableOption "VDPAU video acceleration" // {default = true;};
    };
    prime = {
      enable = mkEnableOption "Nouveau Prime/Offload support" // {default = true;};
    };
  };

  config = mkIf (nouveau.enable
    && !nvidiaPro.enable) {
    boot = {
      kernelParams = [
        "nouveau.config=NvGspRm=1"
        "nouveau.modeset=1"
      ];
      kernelModules = [
        "nouveau"
        "nvidia_wmi_ec_backlight"
      ];
      blacklistedKernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    services.xserver.enable = nvidiaPro.enable && !nouveau.enable;

    # Additional Mesa configuration
    environment = {
      sessionVariables = mkMerge [
        (mkIf nouveau.enable {
          # Shader cache for Nouveau
          MESA_SHADER_CACHE_MAX_SIZE = mkIf gaming.nvidiaOptimizations "10G";

          __GLX_VENDOR_LIBRARY_NAME = "mesa";
        })
        # Aceleración de video
        (mkIf nouveau.acceleration.vaapi {
          LIBVA_DRIVER_NAME = "nouveau";
        })
        (mkIf nouveau.acceleration.vdpau {
          VDPAU_DRIVER = "nouveau";
        })
      ];
    };
  };
}
