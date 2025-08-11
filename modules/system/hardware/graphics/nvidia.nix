# Remember, PRO is not for Professional, it is for Proprietary
{
  pkgs,
  config,
  lib,
  ...
}: {
  options.mars.graphics.nvidia = {
    enable = lib.mkEnableOption "nVidia graphics";
    nvenc = lib.mkEnableOption "NVENC video encoding";
    vulkan = lib.mkEnableOption "Vulkan Support";
    opengl = lib.mkEnableOption "OpenGL Support";
    # Driver selection
    driver = lib.mkOption {
      type = lib.types.enum ["open" "stable" "beta" "production" "legacy_470" "legacy_390"];
      default = "open";
      description = "NVIDIA driver version to use";
    };
    # AI/Compute options
    compute = {
      enable = lib.mkEnableOption "compute/AI optimizations";
      cuda = lib.mkEnableOption "CUDA support" // {default = true;};
      tensorrt = lib.mkEnableOption "TensorRT support";
    };
    hybrid = {
      enable = lib.mkEnableOption "optimus prime";
      igpu = {
        vendor = lib.mkOption {
          type = lib.types.enum ["amd" "intel"];
          default = "amd";
        };
        port = lib.mkOption {
          default = "";
          description = "Bus Port of igpu";
        };
      };
      dgpu.port = lib.mkOption {
        default = "";
        description = "Bus Port of dgpu";
      };
    };
    wayland-fixes = lib.mkEnableOption "Wayland VRAM Consumption Fixes";
  };

  config = let
    cfg = config.mars.graphics;
  in
    lib.mkIf (cfg.enable && cfg.nvidia.enable) {
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
            nvtop # Terminal GPU monitor
            # Graphics utilities
            glxinfo # OpenGL info
            nvidia-settings # NVIDIA control panel
          ]
          ++ lib.optionals cfg.nvidia.vulkan [
            # Vulkan support
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
          ]
          ++
          # AI/Compute packages
          lib.optionals cfg.nvidia.compute.enable [
            # CUDA development
            cudatoolkit

            # Monitoring and management
            nvidia-ml-py # Python ML interface
            nvtop # GPU monitoring

            # Development tools
            nsight-compute # CUDA profiler
            nsight-systems # System profiler
          ]
          ++ lib.optionals (cfg.nvidia.compute.enable && cfg.compute.tensorrt) [
            # TensorRT inference
            # tensorrt
          ];
        sessionVariables = lib.mkMerge [
          {
            GAMEMODERUNEXEC = "prime-run"; # Allows you to switch to the Nvidia GPU when running FeralGamemode
          }
          {
            # Force NVIDIA GPU usage
            __NV_PRIME_RENDER_OFFLOAD = lib.mkIf cfg.gaming.prime.enable "1";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";

            # NVENC
            LIBVA_DRIVER_NAME = lib.mkIf cfg.nvenc "nvidia";
          }
          (lib.mkIf (cfg.compute.enable && cfg.compute.cuda) {
            # CUDA environment
            CUDA_PATH = "${pkgs.cudatoolkit}";
            CUDA_ROOT = "${pkgs.cudatoolkit}";

            # Library paths
            LD_LIBRARY_PATH = "${pkgs.cudatoolkit}/lib:${pkgs.cudatoolkit.lib}/lib";

            # cuDNN
            CUDNN_PATH = lib.mkIf cfg.compute.cudnn "${pkgs.cudnn}";
          })
        ];
      };

      hardware = {
        graphics = {
          extraPackages = with pkgs;
            [
              nvidiaPackages.latest.lib # Vulkan and OpenGL libraries
              nvidia-vaapi-driver
            ]
            ++ lib.optionals cfg.nvenc [
              # Video encoding
              nv-codec-headers
            ]
            ++ lib.optionals cfg.compute.cuda [
              # CUDA runtime
              cudatoolkit
            ];
          extraPackages32 = with pkgs.driversi686Linux; [
            nvidiaPackages.latest.lib # 32-bit Vulkan/OpenGL for Steam
          ];
        };
        nvidia = {
          modesetting.enable = true;
          dynamicBoost.enable = true;

          powerManagement = {
            enable = true;
            finegrained = cfg.hybrid.enable;
          };

          # Use the NVidia open source kernel module (not to be confused with the
          # independent third-party "nouveau" open source driver).
          open = cfg.driver == "open";

          nvidiaSettings = true;
          package =
            if cfg.driver == "stable"
            then config.boot.kernelPackages.nvidiaPackages.stable
            else if cfg.driver == "beta"
            then config.boot.kernelPackages.nvidiaPackages.beta
            else if cfg.driver == "production"
            then config.boot.kernelPackages.nvidiaPackages.production
            else if cfg.driver == "legacy_470"
            then config.boot.kernelPackages.nvidiaPackages.legacy_470
            else if cfg.driver == "legacy_390"
            then config.boot.kernelPackages.nvidiaPackages.legacy_390
            else if cfg.driver == "open"
            then config.boot.kernelPackages.nvidiaPackages.open
            else config.boot.kernelPackages.nvidiaPackages.stable;

          prime = lib.mkIf cfg.hybrid.enable {
            offload = {
              enable = true;
              enableOffloadCmd = true;
              offloadCmdMainProgram = "prime-run"; #= Custom Name to NvidiaPrime Command
            };

            amdgpuBusId = lib.mkIf (cfg.hybrid.igpu.vendor == "amd") cfg.hybrid.igpu.port;
            intelBusId = lib.mkIf (cfg.hybrid.igpu.vendor == "intel") cfg.hybrid.igpu.port;
            nvidiaBusId = cfg.hybrid.dgpu.port;
          };
        };
      };
      environment.etc = lib.mkIf cfg.wayland-fixes {
        wayland-fix = {
          enable = true;
          target = "/etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json";
          text = ''
            {
                "rules": [
                    {
                        "pattern": {
                            "feature": "procname",
                            "matches": ["niri", "sway", "hyprland"]
                        },
                        "profile": "Limit free buffer pool on Wayland compositors"
                    }
                ],
                "profiles": [
                    {
                        "name": "Limit free buffer pool on Wayland compositors",
                        "settings": [
                            {
                                "key": "GLVidHeapReuseRatio",
                                "value": 1
                            }
                        ]
                    }
                ]
            }
          '';
        };
      };
    };
}
