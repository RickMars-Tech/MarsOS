{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
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
        lib.optionals cfg.amd.compute.enable [
          # ROCm platform
          rocmPackages.clr

          # Development tools
          clinfo # OpenCL info
          rocmPackages.rocm-smi # ROCm system management

          # AI frameworks (examples)
          # pytorch-rocm
          # tensorflow-rocm
        ]
        ++ lib.optionals (cfg.amd.compute.enable && cfg.amd.compute.hip) [
          # HIP runtime
          rocmPackages.hip-common
          rocmPackages.rocm-device-libs
        ]
      );

      # ROCm configuration for AI workloads
      systemd.tmpfiles.rules = mkIf (cfg.amd.compute.enable && cfg.amd.compute.rocm) [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];

      # Environment variables
      environment.sessionVariables = mkMerge [
        # Common AMD variables
        {
          # Gaming optimizations
          __GL_SHADER_DISK_CACHE = "1";
          __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

          # https://reddit.com/r/linux_gaming/comments/1mg8vtl/low_latency_gaming_guide/
          MESA_VK_WSI_PRESENT_MODE = "fifo";

          # AMD-specific optimizations
          RADV_PERFTEST = mkIf cfg.amd.vulkan "gpl,ngg,sam,rt";
          AMD_VULKAN_ICD = mkIf cfg.amd.vulkan "RADV";
        }
        # Compute environment
        (mkIf (cfg.amd.compute.enable && cfg.amd.compute.rocm) {
          # ROCm environment
          ROCM_PATH = "${pkgs.rocmPackages.clr}";
          HIP_PATH = "${pkgs.rocmPackages.hip-common}";
        })
      ];
    };
}
