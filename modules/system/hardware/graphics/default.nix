{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf optionals mkEnableOption;
  graphics = config.mars.hardware.graphics;
  intel = graphics.intel;
  amd = graphics.amd;
  nvidiaPro = graphics.nvidiaPro;
  nvidiaFree = graphics.nvidiaFree;
in {
  imports = [
    ./amd
    ./nvidia
    ./intel
  ];

  options.mars.hardware.graphics.enable = mkEnableOption "Enable graphics" // {default = true;};

  config = mkIf graphics.enable {
    # Validaciones para configuraciones híbridas
    assertions = [
      {
        assertion = !(nvidiaPro.enable && nvidiaFree.enable);
        message = "Cannot enable both NVIDIA proprietary and Nouveau drivers simultaneously";
      }
      {
        assertion = amd.enable || intel.enable || nvidiaPro.enable || nvidiaFree.enable;
        message = "At least one graphics driver must be enabled";
      }
    ];

    # Sistemas híbridos (usar con DRI_PRIME=1 o prime-run command)
    # Por defecto usa la iGPU, DRI_PRIME=1||prime-run usa la dGPU
    warnings = let
      hybridConfigs = [
        {
          cond = nvidiaFree.enable && amd.enable;
          msg = "Hybrid graphics detected: Nvidia(Nouveau) + AMD. Use DRI_PRIME=1 to run applications on dGPU.";
        }
        {
          cond = nvidiaFree.enable && intel.enable;
          msg = "Hybrid graphics detected: Nvidia(Nouveau) + Intel. Use DRI_PRIME=1 to run applications on dGPU.";
        }
        {
          cond = nvidiaPro.enable && amd.enable;
          msg = "Hybrid graphics detected: Nvidia(Privative Driver) + AMD. Use prime-run to run applications on dGPU.";
        }
        {
          cond = nvidiaPro.enable && intel.enable;
          msg = "Hybrid graphics detected: Nvidia(Privative Driver) + Intel. Use prime-run to run applications on dGPU.";
        }
      ];
    in
      lib.flatten (map (cfg: optionals cfg.cond [cfg.msg]) hybridConfigs);

    hardware = {
      # AMD GPU initrd
      # amdgpu.initrd.enable = amd.enable;

      # Intel GPU tools
      intel-gpu-tools.enable = intel.enable;

      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs;
          [
            mesa
            mesa-demos
            mesa-gl-headers
            libdrm
            libgbm
            libGL
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
            vulkan-extension-layer
          ]
          ++ optionals (amd.compute.enable && amd.compute.rocm) [
            # ROCm platform
            rocmPackages.clr
            rocmPackages.rocm-runtime
          ]
          # Intel
          ++ optionals intel.enable [
            # Intel media driver (moderno)
            intel-media-driver
            # VAAPI driver (legacy)
            intel-vaapi-driver
            # Intel compute runtime
            intel-compute-runtime
          ]
          ++ optionals (nvidiaFree.enable && nvidiaFree.acceleration.vaapi) [
            libva-vdpau-driver
            libva-utils
          ]
          ++ optionals (nvidiaFree.enable && nvidiaFree.acceleration.vdpau) [
            vdpauinfo
            libvdpau-va-gl
          ];
        # NVIDIA Proprietary
        # ++ optionals nvidiaPro.enable [
        #   # NVIDIA VAAPI driver
        #   nvidia-vaapi-driver
        # ]
        # ++ optionals (nvidiaPro.enable && nvidiaPro.nvenc) [
        #   # Video encoding
        #   nv-codec-headers
        #   libva-utils
        # ]
        # ++ optionals (nvidiaPro.enable && nvidiaPro.compute.enable && nvidiaPro.compute.cuda) [
        #   # CUDA runtime
        #   cudatoolkit
        #   cudaPackages.cudnn
        # ];

        # 32-bit support (para gaming)
        extraPackages32 = with pkgs.driversi686Linux;
          [
            mesa
            mesa-demos
          ]
          ++ optionals intel.enable [
            intel-media-driver
            intel-vaapi-driver
          ]
          ++ optionals (nvidiaFree.enable && nvidiaFree.acceleration.vdpau) [
            libvdpau-va-gl
          ];
      };
    };

    boot = {
      kernelParams = optionals (amd.enable
        && nvidiaPro.enable) [
        # Improved compatibility with AMD iGPU + NVIDIA dGPU
        # "amd_iommu=off"
      ];
      blacklistedKernelModules = [
        "radeon"
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        lact
        mesa
        mesa-demos
        mesa-gl-headers
        libdrm
        libgbm
        libGL
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        vulkan-extension-layer
      ];
      # sessionVariables = let
      #   icdNvidia = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      #   icdRadeon = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
      #   icdIntel = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
      #   icdNouveau = "/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json";
      #   # 32-bit
      #   icdNvidia32 = "/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json";
      #   icdRadeon32 = "/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
      #   icdNouveau32 = "/run/opengl-driver-32/share/vulkan/icd.d/nouveau_icd.i686.json";
      #   icdIntel32 = "/run/opengl-driver-32/share/vulkan/icd.d/intel_icd.i686.json";

      #   vkIcdPath =
      #     if nvidiaPro.enable && amd.enable
      #     then "${icdRadeon}:${icdRadeon32}:${icdNvidia}:${icdNvidia32}" # AMD primero = iGPU por defecto
      #     else if nvidiaPro.enable && intel.enable
      #     then "${icdIntel}:${icdIntel32}:${icdNvidia}:${icdNvidia32}" # Intel primero = iGPU por defecto
      #     else if nvidiaPro.enable
      #     then "${icdNvidia}:${icdNvidia32}" # Solo NVIDIA (sin iGPU)
      #     else if nvidiaFree.enable && amd.enable
      #     then "${icdRadeon}:${icdRadeon32}:${icdNouveau}:${icdNouveau32}"
      #     else if nvidiaFree.enable && intel.enable
      #     then "${icdIntel}:${icdIntel32}:${icdNouveau}:${icdNouveau32}"
      #     else if amd.enable
      #     then "${icdRadeon}:${icdRadeon32}"
      #     else if intel.enable
      #     then "${icdIntel}:${icdIntel32}"
      #     else if nvidiaFree.enable
      #     then "${icdNouveau}:${icdNouveau32}"
      #     else "";
      # in {
      #   VK_ICD_FILENAMES = vkIcdPath;
      # };
    };
  };
}
