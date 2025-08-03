{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.mars.graphics.intel;
in {
  options.mars.graphics.intel = {
    enable = mkEnableOption "intel graphics";
  };
  config = mkIf (cfg.enable && config.mars.graphics.enable) {
    # Kernel parameters for Intel GPU optimization
    boot = {
      kernelParams = [
        "i915.enable_psr=1" # Enable Panel Self-Refresh for power saving
        "i915.enable_rc6=1" # Enable RC6 for power saving
        "i915.enable_fbc=1" # Enable Frame Buffer Compression
        "drm.vblankoffdelay=1" # Reduce VBlank delay for responsiveness
      ];
      initrd.kernelModules = ["i915"]; # Ensure early loading of i915
      # kernelModules = ["vfio" "vfio-pci"]; # Support for GPU passthrough
    };
    #=> OpenGL, Drivers and more...
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-vaapi-driver # VAAPI for video acceleration
          # vpl-gpu-rt # Intel VPL for modern GPUs (Tiger Lake, Arc, etc.)
          libdrm # Direct Rendering Manager
          mesa # OpenGL and Vulkan (iris driver)
        ];
        enable32Bit = true;
        extraPackages32 = with pkgs.driversi686Linux; [
          intel-vaapi-driver
          mesa
          # vpl-gpu-rt
        ];
      };
      intel-gpu-tools.enable = true;
    };
    environment.variables = {
      #|==< Intel Graphics >==|#
      LIBVA_DRIVER_NAME = "i965";
    };
  };
}
