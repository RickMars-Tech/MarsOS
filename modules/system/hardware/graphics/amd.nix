{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals;
in {
  options.mars.graphics.amd = {
    enable = mkEnableOption "amd graphics";
    # API´s
    vulkan = mkEnableOption "Vulkan API support" // {default = true;};
    opengl = mkEnableOption "OpenGL optimizations" // {default = true;};
    # GPU model selection for specific optimizations
    # AI/Compute options
    compute = {
      enable = mkEnableOption "compute/AI optimizations";
      rocm = mkEnableOption "ROCm platform support" // {default = true;};
      openCL = mkEnableOption "OpenCL support" // {default = true;};
      hip = mkEnableOption "HIP runtime support" // {default = true;};
    };
  };
  config = let
    cfg = config.mars.graphics;
  in
    mkIf (cfg.enable && cfg.amd.enable) {
      environment.systemPackages = with pkgs; (
        [
          radeontop
          amdgpu_top
          lact
          vulkan-tools
        ]
        ++
        # AI/Compute packages
        optionals cfg.amd.compute.enable [
          # ROCm platform
          rocmPackages.clr

          # Development tools
          clinfo # OpenCL info
          rocmPackages.rocm-smi # ROCm system management

          # AI frameworks (examples)
          # pytorch-rocm
          # tensorflow-rocm
        ]
        ++ optionals (cfg.amd.compute.enable && cfg.amd.compute.hip) [
          # HIP runtime
          rocmPackages.hip-common
          rocmPackages.rocm-device-libs
        ]
      );
    };
}
