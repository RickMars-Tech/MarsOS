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
      hardware = {
        amdgpu.initrd.enable = true;
        graphics = {
          extraPackages = with pkgs;
            [
              # Mesa drivers
              mesa
            ]
            ++ lib.optionals cfg.amd.vulkan [
              # Vulkan support
              vulkan-loader
              vulkan-validation-layers
              vulkan-tools
            ]
            ++ lib.optionals cfg.amd.compute.rocm [
              # ROCm platform
              rocmPackages.clr
              #rocmPackages.rpp-opencl
            ];
        };
      };

      # Kernel parameters for AMD GPU optimization
      boot = {
        kernelParams = [
          # # Explicitly set amdgpu support in place of radeon
          "radeon.cik_support=0"
          "amdgpu.cik_support=1"
          "radeon.si_support=0"
          "amdgpu.si_support=1"
          "amdgpu.dc=1" # Enable Display Core for better display support
          "amdgpu.dpm=1" # Enable Dynamic Power Management
        ];
        initrd.kernelModules = ["amdgpu"]; # Ensure early loading of amdgpu
        kernelModules = ["vfio" "vfio-pci"]; # Support for GPU passthrough
        blacklistedKernelModules = ["radeon"];
      };

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
        "d /dev/dri 0755 root root"
        "c /dev/kfd 0666 root root - 511:0"
      ];

      # Udev rules for ROCm
      # services.udev.extraRules = mkIf (cfg.amd.compute.enable && cfg.amd.compute.rocm) ''
      #   # ROCm device permissions
      #   SUBSYSTEM=="drm", KERNEL=="renderD*", GROUP="render", MODE="0666"
      #   KERNEL=="kfd", GROUP="render", MODE="0666"
      # '';

      # Environment variables
      environment.sessionVariables = mkMerge [
        # Common AMD variables
        {
          # Gaming optimizations
          __GL_SHADER_DISK_CACHE = "1";
          __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
          # Force AMD GPU usage
          DRI_PRIME = "1";

          # AMD-specific optimizations
          RADV_PERFTEST = mkIf cfg.amd.vulkan "gpl,ngg,sam,rt";
          AMD_VULKAN_ICD = mkIf cfg.amd.vulkan "RADV";
        }
        # Compute environment
        (mkIf (cfg.amd.compute.enable && cfg.amd.compute.rocm) {
          # ROCm environment
          ROCM_PATH = "${pkgs.rocmPackages.clr}";
          HIP_PATH = "${pkgs.rocmPackages.hip-common}";

          # OpenCL
          #OPENCL_VENDOR_PATH = "${pkgs.rocm-opencl-icd}/etc/OpenCL/vendors";
        })
      ];
    };
}
