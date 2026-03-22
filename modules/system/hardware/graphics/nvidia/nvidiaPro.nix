# Remember, PRO is not for Professional, it is for Proprietary
{
  config,
  lib,
  ...
}: let
  cfg = config.mars.hardware.graphics.nvidiaPro;
  nvidiaFree = config.mars.hardware.graphics.nvidiaFree;
  inherit (lib) mkIf mkOption mkEnableOption optionals types;
in {
  options.mars.hardware.graphics.nvidiaPro = {
    enable = mkEnableOption "nVidia graphics" // {default = false;};
    # nvenc = mkEnableOption "NVENC video encoding" // {default = false;};
    driver = mkOption {
      type = types.enum ["stable" "latest" "beta" "legacy_470" "legacy_390"];
      default = "stable";
      description = "NVIDIA driver version to use";
    };
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
    # wayland-fixes = mkEnableOption "Wayland VRAM Consumption Fixes";
  };

  config = mkIf cfg.enable {
    # f#ck, we need this thing to use nvidia privative driver
    services.xserver = {
      enable = cfg.enable && !nvidiaFree.enable;
      videoDrivers = ["nvidia"] ++ optionals cfg.prime.enable ["modesetting"];
    };

    hardware.nvidia = with config.boot.kernelPackages.nvidiaPackages; {
      videoAcceleration = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      dynamicBoost.enable = true;

      open = true;
      #  "stable" "latest" "beta" "legacy_470" "legacy_390"
      package =
        if cfg.driver == "stable"
        then stable
        else if cfg.driver == "latest"
        then latest
        else if cfg.driver == "beta"
        then beta
        else if cfg.driver == "legacy_470"
        then legacy_470
        else if cfg.driver == "legacy_390"
        then legacy_390
        else stable;

      # Hybrid GPU(AMD+NVIDIA or Intel+NVIDIA)
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
          offloadCmdMainProgram = "prime-run";
        };
        amdgpuBusId = mkIf (cfg.prime.igpu.vendor == "amd") cfg.prime.igpu.port;
        intelBusId = mkIf (cfg.prime.igpu.vendor == "intel") cfg.prime.igpu.port;
        nvidiaBusId = cfg.prime.dgpu.port;
      };
    };

    # Fix for openGL nvidia drivers bug (GLThreadedOptimizations)
    home.file = {
      ".nv/nvidia-application-profiles-rc".text = ''
        {
            "rules": [
                {
                    "pattern": {
                        "feature": "dso",
                        "matches": "libGL.so.1"
                    },
                    "profile": "openGL_fix"
                }
            ],
            "profiles": [
                {
                    "name": "openGL_fix",
                    "settings": [
                        {
                            "key": "GLThreadedOptimizations",
                            "value": false
                        }
                    ]
                }
            ]
        }
      '';
    };

    # Wayland Compositors Minor Fix
    environment.etc."nvidia/nvidia-application-profiles-rc.d/niri-wayland".text = ''
      {
          "rules": [
              {
                  "pattern": {
                      "feature": "procname",
                      "matches": "niri"
                  },
                  "profile": "Limit Free Buffer Pool On Wayland Compositors"
              }
          ],
          "profiles": [
              {
                  "name": "Limit Free Buffer Pool On Wayland Compositors",
                  "settings": [
                      {
                          "key": "GLVidHeapReuseRatio",
                          "value": 0
                      }
                  ]
              }
          ]
      }
    '';
  };
}
