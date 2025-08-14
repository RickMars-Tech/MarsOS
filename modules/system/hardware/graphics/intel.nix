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
    enable = mkEnableOption "Intel graphics support";
    vaapi = mkEnableOption "VA-API hardware acceleration" // {default = true;};
    vulkan = mkEnableOption "Vulkan API support" // {default = true;};
    opengl = mkEnableOption "OpenGL optimizations" // {default = true;};

    generation = lib.mkOption {
      type = lib.types.enum ["arc" "xe" "iris-xe" "iris-plus" "uhd" "hd" "legacy"];
      default = "legacy";
      description = "Intel GPU generation for driver optimizations";
    };
  };

  config = mkIf (cfg.enable && config.mars.graphics.enable) {
    boot = {
      initrd.kernelModules = ["i915"];
      kernelParams =
        [
          "i915.enable_guc=2" # Carga GuC/HuC (mejora rendimiento/eficiencia)
          "i915.preempt_timeout=100"
          "i915.timeslice_duration=1"
        ]
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
        mesa-demos
      ]
      ++ lib.optionals cfg.vulkan [vulkan-tools]
      ++ lib.optionals (cfg.generation == "arc" || cfg.generation == "xe") [
        intel-compute-runtime
        clinfo
        level-zero
      ];

    environment.sessionVariables = lib.mkMerge [
      (mkIf cfg.vaapi {
        LIBVA_DRIVER_NAME = "iHD";
        VDPAU_DRIVER = "va_gl";
      })
      (mkIf (cfg.opengl && builtins.elem cfg.generation ["iris-xe" "iris-plus" "uhd" "arc" "xe"]) {
        MESA_LOADER_DRIVER_OVERRIDE = "iris";
      })
    ];
  };
}
