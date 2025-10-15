{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf optionals mkEnableOption;
  intel = config.mars.graphics.intel;
  radeon = config.mars.graphics.amd;
  nvidiaPro = config.mars.graphics.nvidiaPro;
  # nvidiaFree = config.mars.graphics.nvidiaFree;
in {
  imports = [
    ./amd.nix
    ./nvidiaPro.nix
    # ./nvidiaFree.nix
    ./intel.nix
  ];

  options.mars.graphics.enable = mkEnableOption "Enable graphics" // {default = true;};

  config = mkIf (config.mars.graphics.enable) {
    hardware = {
      amdgpu.initrd.enable = radeon.enable;
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs;
          [
            mesa
            libdrm
          ]
          #= AMDGPU
          ++ optionals radeon.enable [
            # Vulkan support
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
          ]
          ++ optionals radeon.compute.rocm [
            # ROCm platform
            rocmPackages.clr
          ]
          #= Intel
          ++ optionals intel.enable [
            intel-vaapi-driver
          ]
          ++ optionals (intel.enable
            && intel.vulkan) [
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
          ]
          #= NvidiaFree
          # ++ optionals nvidiaFree.vulkan [
          #   vulkan-loader
          #   vulkan-validation-layers
          #   vulkan-tools
          # ]
          #= NvidiaPro
          ++ optionals nvidiaPro.enable [
            nvidia-vaapi-driver
          ]
          ++ optionals (nvidiaPro.nvenc
            && nvidiaPro.enable) [
            # Video encoding
            nv-codec-headers
          ]
          ++ optionals (nvidiaPro.compute.cuda
            && nvidiaPro.enable) [
            # CUDA runtime
            cudatoolkit
          ];
        extraPackages32 = with pkgs.driversi686Linux;
          [
            mesa
          ]
          ++ optionals intel.enable [
            intel-vaapi-driver
          ];
      };
      intel-gpu-tools.enable = intel.enable;
    };
    boot.blacklistedKernelModules = ["radeon"];
  };
}
