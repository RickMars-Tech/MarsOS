# Remember, PRO is not for Professional, it is for Proprietary
{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf mkMerge types;
in {
  options.mars.graphics.nvidiaPro = {
    enable = mkEnableOption "nVidia graphics";
    nvenc = mkEnableOption "NVENC video encoding";
    vulkan = mkEnableOption "Vulkan Support" // {default = true;};
    opengl = mkEnableOption "OpenGL Support" // {default = true;};
    # Driver selection
    driver = mkOption {
      type = types.enum ["open" "stable" "beta" "production" "legacy_470" "legacy_390"];
      default = "stable";
      description = "NVIDIA driver version to use";
    };
    # AI/Compute options
    compute = {
      enable = mkEnableOption "compute/AI optimizations";
      cuda = mkEnableOption "CUDA support" // {default = true;};
      tensorrt = mkEnableOption "TensorRT support";
    };
    hybrid = {
      enable = mkEnableOption "optimus prime";
      igpu = {
        vendor = mkOption {
          type = types.enum ["amd" "intel"];
          default = "amd";
        };
        port = mkOption {
          default = "";
          description = "Bus Port of igpu";
        };
      };
      dgpu.port = mkOption {
        default = "";
        description = "Bus Port of dgpu";
      };
    };
    wayland-fixes = mkEnableOption "Wayland VRAM Consumption Fixes";
  };

  config = let
    cfg = config.mars.graphics;
  in
    mkIf (cfg.enable && cfg.nvidiaPro.enable) {
      # Validation para BusIDs
      # assertions = [
      #   {
      #     assertion = cfg.nvidiaPro.hybrid.dgpu.port != null && cfg.nvidiaPro.hybrid.dgpu.port != "";
      #     message = "NVIDIA dGPU BusID must be specified for hybrid mode";
      #   }
      #   {
      #     assertion = cfg.nvidiaPro.hybrid.igpu.port != null && cfg.nvidiaPro.hybrid.igpu.port != "";
      #     message = "iGPU BusID must be specified for hybrid mode";
      #   }
      # ];
      services.xserver.videoDrivers = ["nvidia"];
      # Kernel parameters for NVIDIA
      boot = {
        kernelParams = [
          "nvidia-drm.modeset=1" # Improve Wayland compatibility
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Preserve VRAM on suspend
        ];
        blacklistedKernelModules = ["nouveau"];
      };

      environment = {
        systemPackages = with pkgs;
          [
            # nVidia Desktop tools packages
            zenith-nvidia # Top but for Nvidia
            nvidia-system-monitor-qt # GPU monitoring
            #nvtop # Terminal GPU monitor
            # Graphics utilities
            glxinfo # OpenGL info
            #nvidia-settings # NVIDIA control panel
          ]
          ++ lib.optionals cfg.nvidiaPro.vulkan [
            # Vulkan support
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
          ]
          ++
          # AI/Compute packages
          lib.optionals cfg.nvidiaPro.compute.enable [
            # CUDA development
            cudatoolkit

            # Monitoring and management
            #nvidia-ml-py # Python ML interface
            #nvtop # GPU monitoring

            # Development tools
            cudaPackages.nsight_compute # CUDA profiler
            cudaPackages.nsight_systems # System profiler
          ]
          ++ lib.optionals (cfg.nvidiaPro.compute.enable && cfg.nvidiaPro.compute.tensorrt) [
            # TensorRT inference
            # tensorrt
          ];
        sessionVariables = mkMerge [
          {
            # NVENC
            LIBVA_DRIVER_NAME = mkIf cfg.nvidiaPro.nvenc "nvidia";
          }
          (mkIf (cfg.nvidiaPro.compute.enable && cfg.nvidiaPro.compute.cuda) {
            # CUDA environment
            CUDA_PATH = "${pkgs.cudatoolkit}";
            CUDA_ROOT = "${pkgs.cudatoolkit}";

            # Library paths
            #LD_LIBRARY_PATH = "${pkgs.cudatoolkit}/lib:${pkgs.cudatoolkit.lib}/lib";

            # cuDNN
            # CUDNN_PATH = mkIf cfg.nvidiaPro.compute.cudnn "${pkgs.cudaPackages.cudnn}";
          })
        ];
      };

      hardware = {
        graphics = {
          extraPackages = with pkgs;
            [
              #nvidiaPackages.latest.lib # Vulkan and OpenGL libraries
              nvidia-vaapi-driver
            ]
            ++ lib.optionals cfg.nvidiaPro.nvenc [
              # Video encoding
              nv-codec-headers
            ]
            ++ lib.optionals cfg.nvidiaPro.compute.cuda [
              # CUDA runtime
              cudatoolkit
            ];
          #extraPackages32 = with pkgs.driversi686Linux; [
          #  nvidiaPackages.latest.lib # 32-bit Vulkan/OpenGL for Steam
          #];
        };
        nvidia = {
          modesetting.enable = true;
          dynamicBoost.enable = true;

          powerManagement = {
            enable = true;
            finegrained = cfg.nvidiaPro.hybrid.enable;
          };

          # Use the NVidia open source kernel module (not to be confused with the
          # independent third-party "nouveau" open source driver).
          open = cfg.nvidiaPro.driver == "open";

          nvidiaSettings = true;
          package =
            if cfg.nvidiaPro.driver == "stable"
            then config.boot.kernelPackages.nvidiaPackages.stable
            else if cfg.nvidiaPro.driver == "beta"
            then config.boot.kernelPackages.nvidiaPackages.beta
            else if cfg.nvidiaPro.driver == "production"
            then config.boot.kernelPackages.nvidiaPackages.production
            else if cfg.nvidiaPro.driver == "legacy_470"
            then config.boot.kernelPackages.nvidiaPackages.legacy_470
            else if cfg.nvidiaPro.driver == "legacy_390"
            then config.boot.kernelPackages.nvidiaPackages.legacy_390
            else if cfg.nvidiaPro.driver == "open"
            then config.boot.kernelPackages.nvidiaPackages.open
            else config.boot.kernelPackages.nvidiaPackages.stable;

          #= Nvidia Prime/Optimus
          prime = mkIf cfg.nvidiaPro.hybrid.enable {
            offload = {
              enable = true;
              enableOffloadCmd = true;
              # offloadCmdMainProgram = "prime-run"; #= Custom Name to NvidiaPrime Command
            };

            amdgpuBusId = mkIf (cfg.nvidiaPro.hybrid.igpu.vendor == "amd") cfg.nvidiaPro.hybrid.igpu.port;
            intelBusId = mkIf (cfg.nvidiaPro.hybrid.igpu.vendor == "intel") cfg.nvidiaPro.hybrid.igpu.port;
            nvidiaBusId = cfg.nvidiaPro.hybrid.dgpu.port;
          };
        };
      };
      environment.etc = mkIf cfg.nvidiaPro.wayland-fixes {
        "nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json" = {
          text = builtins.toJSON {
            rules = [
              {
                pattern = {
                  feature = "procname";
                  matches = ["niri" "sway" "hyprland" "weston" "mutter"];
                };
                profile = "Limit free buffer pool on Wayland compositors";
              }
            ];
            profiles = [
              {
                name = "Limit free buffer pool on Wayland compositors";
                settings = [
                  {
                    key = "GLVidHeapReuseRatio";
                    value = 1;
                  }
                  {
                    key = "GLUseEGL";
                    value = 1;
                  }
                ];
              }
            ];
          };
        };
      };
    };
}
