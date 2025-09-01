{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf types mkMerge mkOption mkEnableOption;
  graphics = config.mars.graphics;
  intel = config.mars.graphics.intel;
in {
  options.mars.graphics.intel = {
    enable = mkEnableOption "Intel graphics support";
    vaapi = mkEnableOption "VA-API hardware acceleration" // {default = true;};
    vulkan = mkEnableOption "Vulkan API support" // {default = true;};
    opengl = mkEnableOption "OpenGL optimizations" // {default = true;};

    generation = mkOption {
      type = types.enum ["arc" "xe" "iris-xe" "iris-plus" "uhd" "hd" "legacy"];
      default = "legacy";
      description = "Intel GPU generation for driver optimizations";
    };
  };

  config = mkIf (intel.enable && graphics.enable) {
    environment = {
      # systemPackages = with pkgs;
      #   [
      #     intel-gpu-tools
      #     libva-utils
      #     glxinfo
      #   ]
      #   ++ options intel.vulkan [vulkan-tools]
      #   ++ options (intel.generation == "arc" || intel.generation == "xe") [
      #     intel-compute-runtime
      #     clinfo
      #     level-zero
      #   ];
      sessionVariables = mkMerge [
        (mkIf intel.vaapi {
          LIBVA_DRIVER_NAME = "iHD";
          VDPAU_DRIVER = "va_gl";
        })
        (mkIf (intel.opengl && builtins.elem intel.generation ["iris-xe" "iris-plus" "uhd" "arc" "xe"]) {
          MESA_LOADER_DRIVER_OVERRIDE = "iris";
        })
      ];
    };
  };
}
