{
  pkgs,
  config,
  lib,
  ...
}: {
  options.mars.graphics.amd.enable = lib.mkEnableOption "amd graphics";

  config = lib.mkIf (config.mars.graphics.amd.enable && config.mars.graphics.enable) {
    environment.systemPackages = with pkgs; [
      radeontop
      amdgpu_top
      corectrl
      vulkan-tools
    ];
    hardware = {
      amdgpu.initrd.enable = lib.mkDefault true;
      graphics = {
        extraPackages = with pkgs; [
          #amdvlk
          rocmPackages.clr.icd
          rocmPackages.rocm-runtime
          vaapiVdpau
          libvdpau-va-gl
        ];

        #extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
      };
    };

    # Kernel parameters for AMD GPU optimization
    boot = {
      kernelParams = [
        # Explicitly set amdgpu support in place of radeon
        "radeon.cik_support=0"
        "amdgpu.cik_support=1"
        "radeon.si_support=0"
        "amdgpu.si_support=1"
        "amdgpu.dc=1" # Enable Display Core for better display support
        "amdgpu.dpm=1" # Enable Dynamic Power Management
      ];
      initrd.kernelModules = ["amdgpu"]; # Ensure early loading of amdgpu
      kernelModules = ["vfio" "vfio-pci"]; # Support for GPU passthrough
    };

    services.xserver.videoDrivers = lib.mkDefault ["modesetting"];

    # amd hip workaround
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    programs.gamemode.settings = {
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        amd_performance_level = "high";
      };
    };
  };
}
