{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption optionals mkIf;
  graphics = config.mars.graphics;
  amd = config.mars.graphics.amd;
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
  config = mkIf (amd.enable && graphics.enable) {
    boot.kernelParams = [
      # "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
      # "amdgpu.mcbp=0"
      # Explicitly set amdgpu support in place of radeon
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "radeon.si_support=0"
      "amdgpu.si_support=1"
      # "amdgpu.dpm=1" # Enable Dynamic Power Management
    ];
    environment.systemPackages = with pkgs;
      [
        radeontop
        amdgpu_top
        lact
        vulkan-tools
      ]
      ++ optionals amd.compute.enable [
        # ROCm platform
        rocmPackages.clr

        # Development tools
        clinfo # OpenCL info
        rocmPackages.rocm-smi # ROCm system management

        # AI frameworks (examples)
        # pytorch-rocm
        # tensorflow-rocm
      ]
      ++ optionals (amd.compute.enable && amd.compute.hip) [
        # HIP runtime
        rocmPackages.hip-common
        rocmPackages.rocm-device-libs
      ];
  };
}
