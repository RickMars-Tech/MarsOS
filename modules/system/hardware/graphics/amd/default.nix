{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption optionals mkMerge mkIf;
  graphics = config.mars.hardware.graphics;
  amd = config.mars.hardware.graphics.amd;
  nvidiaPro = config.mars.hardware.graphics.nvidiaPro;
  nvidiaFree = config.mars.hardware.graphics.nvidiaFree;
  laptop = config.mars.hardware.laptopOptimizations;
  gaming = config.mars.gaming.gamemode;
in {
  options.mars.hardware.graphics.amd = {
    enable = mkEnableOption "amd graphics";
    # API´s
    # vulkan = mkEnableOption "Vulkan API support" // {default = true;};
    # opengl = mkEnableOption "OpenGL optimizations" // {default = true;};
    # GPU model selection for specific optimizations
    # AI/Compute options
    compute = {
      enable = mkEnableOption "compute/AI optimizations" // {default = false;};
      rocm = mkEnableOption "ROCm platform support" // {default = false;};
      openCL = mkEnableOption "OpenCL support" // {default = false;};
      hip = mkEnableOption "HIP runtime support" // {default = false;};
    };
  };
  config = mkIf (amd.enable && graphics.enable) {
    boot = {
      kernelParams =
        [
          "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
          # Explicitly set amdgpu support in place of radeon
          "radeon.cik_support=0"
          "amdgpu.cik_support=1"
          "radeon.si_support=0"
          "amdgpu.si_support=1"
          "amdgpu.sg_display=0"
          # "iommu=pt"
        ]
        ++ optionals laptop [
          # Avoid idle problems on AMD
          "idle=nomwait"
          # Enable AMD GPU Recovery
          "amdgpu.gpu_recovery=1"
        ]
        ++ optionals amd.compute.enable [
          # Compute optimizations
          "amdgpu.vm_fragment_size=9"
          "amdgpu.vm_block_size=9"
        ];
    };
    environment = {
      sessionVariables = mkMerge [
        (mkIf (amd.enable) {
          AMD_VULKAN_ICD = "RADV";
        })
        (mkIf (!nvidiaFree.enable && !nvidiaPro.enable) {
          RADV_PERFTEST = mkIf gaming.amdOptimizations "gpl,ngg,sam,rt";
          AMD_DEBUG = mkIf (!gaming.amdOptimizations) "nooverclocking";
          mesa_glthread = mkIf gaming.amdOptimizations "true";
          MESA_EXTENSION_OVERRIDE = mkIf gaming.amdOptimizations "+GL_ARB_half_float_pixel";
          MESA_SHADER_CACHE_MAX_SIZE = mkIf gaming.amdOptimizations "12G";
        })
        (mkIf (amd.compute.enable && amd.compute.rocm) {
          # ROCm environment
          ROCM_PATH = "${pkgs.rocmPackages.clr}";
          HIP_PATH = "${pkgs.rocmPackages.hip-common}";
        })
      ];
      systemPackages = with pkgs;
        [
          radeontop
          amdgpu_top
          # lact
          # vulkan-tools
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
  };
}
