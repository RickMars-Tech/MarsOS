{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf optionals mkEnableOption;
  graphics = config.mars.graphics;
  intel = graphics.intel;
  amd = graphics.amd;
  nvidiaPro = graphics.nvidiaPro;
  nvidiaFree = graphics.nvidiaFree;
in {
  imports = [
    ./amd.nix
    ./nvidiaPro.nix
    ./nvidiaFree.nix
    ./intel.nix
  ];

  options.mars.graphics.enable = mkEnableOption "Enable graphics" // {default = true;};

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
    warnings =
      (optionals (nvidiaFree.enable && amd.enable) [
        "Hybrid graphics detected: Nvidia(Nouveau) + AMD. Use DRI_PRIME=1 to run applications on dGPU."
      ])
      ++ (optionals (nvidiaFree.enable && intel.enable) [
        "Hybrid graphics detected: Nvidia(Nouveau) + Intel. Use DRI_PRIME=1 to run applications on dGPU."
      ])
      ++ (optionals (nvidiaPro.enable && amd.enable) [
        "Hybrid graphics detected: Nvidia(Privative Driver) + AMD. Use prime-run to run applications on dGPU."
      ])
      ++ (optionals (nvidiaPro.enable && intel.enable) [
        "Hybrid graphics detected: Nvidia(Privative Driver) + Intel. Use prime-run to run applications on dGPU."
      ]);

    #= Linux GPU Configuration Tool for AMD and NVIDIA
    services.lact.enable = nvidiaFree.enable || nvidiaPro.enable || amd.enable;

    hardware = {
      # AMD GPU initrd
      amdgpu.initrd.enable = amd.enable;

      # Intel GPU tools
      intel-gpu-tools.enable = intel.enable;

      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs;
          [
            # Base Mesa drivers
            mesa
            libdrm
          ]
          #|==< AMD/Radeon >==|#
          ++ optionals (amd.enable && amd.vulkan) [
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
            vulkan-extension-layer
          ]
          ++ optionals (amd.enable && amd.opengl) [
            # OpenGL para AMD ya viene con mesa
          ]
          ++ optionals (amd.compute.enable && amd.compute.rocm) [
            # ROCm platform
            rocmPackages.clr
            rocmPackages.rocm-runtime
          ]
          #|==< Intel >==|#
          ++ optionals intel.enable [
            # Intel media driver (moderno)
            intel-media-driver
            # VAAPI driver (legacy)
            intel-vaapi-driver
            # Intel compute runtime
            intel-compute-runtime
          ]
          ++ optionals (intel.enable && intel.vulkan) [
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
            vulkan-extension-layer
          ]
          #|==< Nouveau (nvidiaFree) >==|#
          ++ optionals (nvidiaFree.enable && nvidiaFree.vulkan) [
            # NVK (Nouveau Vulkan)
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
            vulkan-extension-layer
          ]
          ++ optionals (nvidiaFree.enable && nvidiaFree.acceleration.vaapi) [
            libva-vdpau-driver
            libva-utils
          ]
          ++ optionals (nvidiaFree.enable && nvidiaFree.acceleration.vdpau) [
            vdpauinfo
            libvdpau-va-gl
          ]
          #|==< NVIDIA Proprietary >==|#
          ++ optionals nvidiaPro.enable [
            # NVIDIA VAAPI driver
            nvidia-vaapi-driver
          ]
          ++ optionals (nvidiaPro.enable && nvidiaPro.vulkan) [
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
            vulkan-extension-layer
          ]
          ++ optionals (nvidiaPro.enable && nvidiaPro.nvenc) [
            # Video encoding
            nv-codec-headers
            libva-utils
          ]
          ++ optionals (nvidiaPro.enable && nvidiaPro.compute.enable && nvidiaPro.compute.cuda) [
            # CUDA runtime
            cudatoolkit
            cudaPackages.cudnn
          ];

        # 32-bit support (para gaming)
        extraPackages32 = with pkgs.driversi686Linux;
          [
            mesa
          ]
          ++ optionals intel.enable [
            intel-media-driver
            intel-vaapi-driver
          ]
          ++ optionals nvidiaFree.enable [
            # Mesa 32-bit
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
        "amd_iommu=off"
      ];
      blacklistedKernelModules =
        [
          "radeon" # Driver antiguo de AMD, siempre bloqueado
        ]
        # Solo bloquear nvidia si nouveau está activo
        ++ optionals (nvidiaFree.enable && !nvidiaPro.enable) [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ]
        # Solo bloquear nouveau si nvidia propietario está activo
        ++ optionals (nvidiaPro.enable && !nvidiaFree.enable) [
          "nouveau"
        ];
    };

    # Variables de entorno globales
    environment.sessionVariables = {
      # Mesa optimizations
      MESA_GLTHREAD = "true";

      # Vulkan ICD paths (prioriza según disponibilidad)
      VK_ICD_FILENAMES =
        if nvidiaPro.enable
        then "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json"
        else if nvidiaFree.enable && amd.enable
        then
          # Hybrid: Nouveau + AMD (lista ambos)
          "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json"
        else if nvidiaFree.enable && intel.enable
        then
          # Hybrid: Nouveau + Intel (lista ambos)
          "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json"
        else if amd.enable
        then "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json"
        else if intel.enable
        then "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json"
        else if nvidiaFree.enable
        then "/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json"
        else "";
    };
  };
}
