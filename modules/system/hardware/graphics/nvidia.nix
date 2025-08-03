{
  pkgs,
  config,
  lib,
  ...
}: {
  options.mars.graphics.nvidia = {
    enable = lib.mkEnableOption "nVidia graphics";
    wayland-fixes = lib.mkEnableOption "Wayland VRAM Consumption Fixes";
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
  };

  config = let
    cfg = config.mars.graphics.nvidia;
  in
    lib.mkIf (cfg.enable && config.mars.graphics.enable) {
      # Kernel parameters for NVIDIA
      boot = {
        kernelParams = [
          "nvidia-drm.modeset=1" # Improve Wayland compatibility
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Preserve VRAM on suspend
        ];
        blacklistedKernelModules = ["nouveau"];
      };
      nix.settings = {
        extra-substituters = [
          "https://cuda-maintainers.cachix.org"
          "https://aseipp-nix-cache.global.ssl.fastly.net"
        ];
        extra-trusted-public-keys = [
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };
      #services.xserver.videoDrivers = ["nvidia"];
      environment = {
        systemPackages = [pkgs.zenith-nvidia]; # Top but for Nvidia
        sessionVariables.GAMEMODERUNEXEC = "prime-run"; # Allows you to switch to the Nvidia GPU when running FeralGamemode
      };

      hardware = {
        graphics = {
          extraPackages = with pkgs; [
            nvidiaPackages.latest.lib # Vulkan and OpenGL libraries
            cudaPackages.cudatoolkit # CUDA for GPGPU
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
          open =
            if lib.versionOlder config.hardware.nvidia.package.version "560"
            then false
            else true;

          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.latest;

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
