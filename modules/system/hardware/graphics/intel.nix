{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mars.graphics.intel;
in {
  options.mars.graphics.intel = {
    enable = mkEnableOption "Intel graphics";
    vaapi = mkEnableOption "VA-API hardware acceleration" // {default = true;};
    vulkan = mkEnableOption "Vulkan API support" // {default = true;};
    opengl = mkEnableOption "OpenGL optimizations" // {default = true;};

    # Intel GPU generation (sin "auto", por defecto "legacy")
    generation = lib.mkOption {
      type = lib.types.enum ["arc" "xe" "iris-xe" "iris-plus" "uhd" "hd" "legacy"];
      default = "legacy";
      description = "Intel GPU generation for specific optimizations";
    };

    # Power management: todas las opciones ahora hacen algo
    powerManagement = {
      enable = mkEnableOption "Intel GPU power management" // {default = true;};
      rc6 = mkEnableOption "RC6 power saving states" // {default = true;};
      fbc = mkEnableOption "Frame Buffer Compression" // {default = true;};
      psr = mkEnableOption "Panel Self Refresh" // {default = true;};
    };
  };

  config = mkIf (cfg.enable && config.mars.graphics.enable) {
    boot = {
      initrd.kernelModules = ["i915"];

      kernelParams =
        [
          # GuC/HuC firmware loading (mejora rendimiento y eficiencia)
          "i915.enable_guc=2"
        ]
        # Solo aplica optimizaciones si powerManagement está habilitado
        ++ lib.optional (cfg.powerManagement.enable && cfg.powerManagement.fbc) "i915.enable_fbc=1"
        ++ lib.optional (cfg.powerManagement.enable && cfg.powerManagement.psr) "i915.enable_psr=1"
        ++ lib.optional (cfg.powerManagement.enable && cfg.powerManagement.rc6) "i915.enable_rc6=1"
        ++ [
          # Otras optimizaciones generales
          "i915.preempt_timeout=100"
          "i915.timeslice_duration=1"
        ]
        # Optimizaciones específicas para Arc/Xe
        ++ lib.optionals (cfg.generation == "arc" || cfg.generation == "xe") [
          "i915.force_probe=*"
          "i915.enable_dc=2"
        ];
    };

    hardware = {
      graphics = {
        extraPackages = with pkgs;
          [
            intel-vaapi-driver
            # vpl-gpu-rt                  # Descomenta para Tiger Lake, Alder Lake, Arc
            libdrm
            mesa
          ]
          ++ lib.optionals cfg.vulkan [
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
          ];

        enable32Bit = true;
        extraPackages32 = with pkgs.driversi686Linux; [
          intel-vaapi-driver
          mesa
        ];
      };

      intel-gpu-tools.enable = true;
    };

    environment.systemPackages = with pkgs;
      [
        intel-gpu-tools
        libva-utils
        glxinfo
        vulkan-tools
        mesa-demos
      ]
      ++ lib.optionals (cfg.generation == "arc" || cfg.generation == "xe") [
        intel-compute-runtime
        clinfo
        level-zero
      ];

    environment.sessionVariables = lib.mkMerge [
      {
        # VA-API: solo si está habilitado
        LIBVA_DRIVER_NAME = lib.mkIf cfg.vaapi "iHD";
        VDPAU_DRIVER = "va_gl";
      }

      {
        # Mesa: usa Iris solo para Gen8+ (iris-xe, iris-plus, uhd, etc.)
        MESA_LOADER_DRIVER_OVERRIDE =
          lib.mkIf
          (cfg.opengl && (cfg.generation == "iris-xe" || cfg.generation == "iris-plus" || cfg.generation == "uhd"))
          "iris";
      }
    ];
  };
}
