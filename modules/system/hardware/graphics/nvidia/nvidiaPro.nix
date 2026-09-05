# Remember, PRO is not for Professional, it is for Proprietary
{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption optionals types;
  cfg = config.mars.hardware.graphics.nvidiaPro;
  inherit (config.mars.hardware.graphics) nvidiaFree;
  isLaptop = config.mars.hardware.laptopOptimizations;
in {
  options.mars.hardware.graphics.nvidiaPro = {
    enable = mkEnableOption "nVidia graphics" // {default = false;};
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
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams =
        [
          "nvidia.NVreg_EnableResizableBar=1"
          "nvidia.NVreg_UsePageAttributeTable=1"
          "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1,RMIntrLockingMode=1,PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x1"
        ]
        ++ optionals isLaptop [
          "NVreg_RegistryDwords=OverrideMaxPerf=0x1"
        ];
      kernelModules =
        optionals cfg.enable [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ]
        ++ optionals (cfg.enable && cfg.prime.enable) [
          "nvidia_wmi_ec_backlight"
        ];
    };

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
      powerManagement = {
        inherit (cfg.prime) enable;
        kernelSuspendNotifier = config.hardware.nvidia.open && lib.versionAtLeast config.hardware.nvidia.package.version "595";
      };

      open = true;
      #  "stable" "latest" "beta" "legacy_470" "legacy_390"
      package =
        if cfg.driver == "stable"
        then stable
        else if cfg.driver == "beta"
        then beta
        else if cfg.driver == "legacy_470"
        then legacy_470
        else if cfg.driver == "legacy_390"
        then legacy_390
        else if cfg.driver == "latest"
        # latest
        then
          mkDriver {
            version = "595.58.03";
            sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
            sha256_aarch64 = "sha256-hzzIKY1Te8QkCBWR+H5k1FB/HK1UgGhai6cl3wEaPT8=";
            openSha256 = "sha256-6LvJyT0cMXGS290Dh8hd9rc+nYZqBzDIlItOFk8S4n8=";
            settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c=";
            persistencedSha256 = "sha256-AtjM/ml/ngZil8DMYNH+P111ohuk9mWw5t4z7CHjPWw=";
          }
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

    environment.etc = {
      # Fix for openGL nvidia drivers bug (GLThreadedOptimizations)
      "nvidia/nvidia-application-profiles-rc.d/GLThreadedOptimizations".text = ''
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
      # Wayland Compositors Minor Fix
      "nvidia/nvidia-application-profiles-rc.d/niri-wayland".text = ''
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
  };
}
