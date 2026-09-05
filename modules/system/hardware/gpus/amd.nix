{
  flake.modules.nixos.amdgpu =
    { pkgs, ... }:
    {
      hardware.amdgpu = {
        initrd.enable = true;
        # amdgpu instead of radeon
        legacySupport.enable = true;
      };
      boot = {
        kernelParams = [
          "gpu_sched.sched_policy=0"
          "radeon.cik_support=0"
          "amdgpu.cik_support=1"
          "radeon.si_support=0"
          "amdgpu.si_support=1"
          "amdgpu.sg_display=0"
          "amdgpu.gpu_recovery=1"
        ];
      };
      environment = {
        sessionVariables = {
          AMD_VULKAN_ICD = "RADV";
        };
        systemPackages = with pkgs; [
          radeontop
          amdgpu_top
        ];
      };
    };
  flake.modules.nixos.rocm =
    { pkgs, ... }:
    {
      boot.kernelParams = [
        # Compute optimizations
        "amdgpu.vm_fragment_size=9"
        "amdgpu.vm_block_size=9"
      ];
      environment.sessionVariables = {
        ROCM_PATH = "${pkgs.rocmPackages.clr}";
        HIP_PATH = "${pkgs.rocmPackages.hip-common}";
      };
      systemPackages = with pkgs; [
        # ROCm platform
        rocmPackages.clr

        # Development tools
        clinfo # OpenCL info
        rocmPackages.rocm-smi # ROCm system management

        # HIP runtime
        rocmPackages.hip-common
        rocmPackages.rocm-device-libs
      ];
      # ROCm
      systemd.tmpfiles.rules = [
        "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
      ];

      hardware = {
        amdgpu.opencl.enable = true;
        graphics.extraPackages = with pkgs; [
          rocmPackages.clr
          rocmPackages.rocm-runtime
        ];
      };
    };
}
