{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  nouveau = config.mars.graphics.nvidiaFree;
  nvidiaPro = config.mars.graphics.nvidiaPro;
in {
  options.mars.graphics.nvidiaFree = {
    enable = mkEnableOption "Enable Free nVidia graphics Nouveau" // {default = !nvidiaPro.enable;};
    vulkan = mkEnableOption "Vulkan Support via NVK" // {default = true;};
    opengl = mkEnableOption "OpenGL Support" // {default = true;};
    zink = mkEnableOption "Enable Zink OpenGL-on-Vulkan" // {default = false;};
    acceleration = {
      vaapi = mkEnableOption "VAAPI video acceleration" // {default = true;};
      vdpau = mkEnableOption "VDPAU video acceleration" // {default = true;};
    };    
  };

  config = mkIf (nouveau.enable
    && !nvidiaPro.enable) {
    boot = {
      kernelParams = [
        "nouveau.config=NvGspRm=1"
      ];
      kernelModules = [
        "nouveau"
        "nvidia-open"
        "nvidia_wmi_ec_backlight"
      ];
      blacklistedKernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      extraModprobeConfig = ''
        # Nouveau configuration
        options nouveau modeset=1
      '';
    };

    services.xserver.videoDrivers = ["nouveau"];

    # Additional Mesa configuration
    environment = {
      sessionVariables = mkMerge [
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
