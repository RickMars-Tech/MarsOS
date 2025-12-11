# Remember, PRO is not for Professional, it is for Proprietary
{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption optionals mkForce mkIf mkMerge types;
  graphics = config.mars.graphics;
  nvidiaPro = config.mars.graphics.nvidiaPro;
in {
  options.mars.graphics.nvidiaPro = {
    enable = mkEnableOption "nVidia graphics" // {default = false;};
    nvenc = mkEnableOption "NVENC video encoding" // {default = false;};
    vulkan = mkEnableOption "Vulkan Support" // {default = true;};
    opengl = mkEnableOption "OpenGL Support" // {default = true;};
    # Driver selection
    driver = mkOption {
      type = types.enum ["stable" "latest" "beta" "production" "legacy_470" "legacy_390"];
      default = "stable";
      description = "NVIDIA driver version to use";
    };
    # AI/Compute options
    compute = {
      enable = mkEnableOption "compute/AI optimizations" // {default = false;};
      cuda = mkEnableOption "CUDA support" // {default = false;};
      tensorrt = mkEnableOption "TensorRT support" // {default = false;};
    };
    prime = {
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

  config = mkIf (graphics.enable && nvidiaPro.enable) {
    # Validation para BusIDs
    assertions = [
      {
        assertion = nvidiaPro.prime.dgpu.port != null && nvidiaPro.prime.dgpu.port != "";
        message = "NVIDIA dGPU BusID must be specified for hybrid mode";
      }
      {
        assertion = nvidiaPro.prime.igpu.port != null && nvidiaPro.prime.igpu.port != "";
        message = "iGPU BusID must be specified for hybrid mode";
      }
    ];

    boot = {
      kernelParams =
        optionals nvidiaPro.enable [
          "nvidia-drm.modeset=1"
          "nvidia.NVreg_UsePageAttributeTable=1"
          "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1,RMIntrLockingMode=1"
        ]
        ++ optionals (nvidiaPro.enable && !nvidiaPro.prime.enable) [
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        ];

      kernelModules =
        optionals nvidiaPro.enable [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ]
        ++ optionals (nvidiaPro.enable && nvidiaPro.prime.enable) [
          "nvidia_wmi_ec_backlight"
        ];

      blacklistedKernelModules = optionals nvidiaPro.enable [
        "nouveau"
      ];
    };

    services.xserver.videoDrivers = ["nvidia"];

    environment.systemPackages = with pkgs;
      [
        # nVidia Desktop tools packages
        zenith-nvidia # Top but for Nvidia
        nvidia-system-monitor-qt # GPU monitoring
      ]
      ++ optionals nvidiaPro.vulkan [
        # Vulkan support
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
      ]
      ++
      # AI/Compute packages
      optionals nvidiaPro.compute.enable [
        # CUDA development
        cudatoolkit

        # Development tools
        cudaPackages.nsight_compute # CUDA profiler
        cudaPackages.nsight_systems # System profiler
      ]
      ++ optionals (nvidiaPro.compute.enable && nvidiaPro.compute.tensorrt) [
        # TensorRT inference
        # tensorrt
      ];

    environment.sessionVariables = mkMerge [
      {
        # NVENC
        LIBVA_DRIVER_NAME = mkIf nvidiaPro.nvenc "nvidia";
      }
      (mkIf (nvidiaPro.compute.enable && nvidiaPro.compute.cuda) {
        # CUDA environment
        CUDA_PATH = "${pkgs.cudatoolkit}";
        CUDA_ROOT = "${pkgs.cudatoolkit}";
      })
    ];

    hardware = {
      nvidia = {
        modesetting.enable = true;
        dynamicBoost.enable = true;

        powerManagement = {
          enable = false;
          finegrained = mkForce false;
        };

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        open = nvidiaPro.driver == "open";

        nvidiaSettings = true;
        package =
          if nvidiaPro.driver == "stable"
          then config.boot.kernelPackages.nvidiaPackages.stable
          else if nvidiaPro.driver == "beta"
          then config.boot.kernelPackages.nvidiaPackages.beta
          else if nvidiaPro.driver == "production"
          then config.boot.kernelPackages.nvidiaPackages.production
          else if nvidiaPro.driver == "legacy_470"
          then config.boot.kernelPackages.nvidiaPackages.legacy_470
          else if nvidiaPro.driver == "legacy_390"
          then config.boot.kernelPackages.nvidiaPackages.legacy_390
          else config.boot.kernelPackages.nvidiaPackages.stable;

        #= Nvidia Prime/Optimus
        prime = mkIf nvidiaPro.prime.enable {
          offload = {
            enable = true;
            enableOffloadCmd = true;
            offloadCmdMainProgram = "prime-run"; #= Custom Name to NvidiaPrime Command
          };

          amdgpuBusId = mkIf (nvidiaPro.prime.igpu.vendor == "amd") nvidiaPro.prime.igpu.port;
          intelBusId = mkIf (nvidiaPro.prime.igpu.vendor == "intel") nvidiaPro.prime.igpu.port;
          nvidiaBusId = nvidiaPro.prime.dgpu.port;
        };
      };
    };
    environment.etc = mkIf nvidiaPro.wayland-fixes {
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
                  value = 0;
                }
                {
                  key = "GLUseEGL";
                  value = 0;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
