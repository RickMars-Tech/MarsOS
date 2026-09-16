# Remember, PRO is not for Professional, it is for Privative
{
  flake.modules.nixos.nvidia-pro =
    {
      config,
      pkgs,
      ...
    }:
    {
      boot = {
        kernelParams = [
          "nvidia.NVreg_EnableResizableBar=1"
          "nvidia.NVreg_UsePageAttributeTable=1"
          "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1,RMIntrLockingMode=1,PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x1;OverrideMaxPerf=0x1"
        ];
      };
      services.xserver = {
        enable = true;
        videoDrivers = [ "nvidia" ];
      };

      hardware.nvidia = {
        videoAcceleration = true;
        nvidiaSettings = false;
        modesetting.enable = true;
        dynamicBoost.enable = true;
        open = true;
        # package = config.boot.kernelPackages.nvidiaPackages.latest;
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "615.71.09";
          sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
          sha256_aarch64 = "sha256-IbekQhE7cFfmnPZaLY9NDYcF7CoNZ+2Qb7sRd4EOgWM=";
          openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
          settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
          persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
        };
      };

      environment = {
        systemPackages = with pkgs; [
          dlss-swapper
          dlss-swapper-dll
        ];
        etc = {
          "nvidia/nvidia-application-profiles-rc.d/GLThreadedOptimizations".text = ''
            {
              "rules": [
                  {"pattern": {"feature": "dso", "matches": "libGL.so.1"}, "profile": "openGL_fix"}
              ],
              "profiles": [
                  {"name": "openGL_fix", "settings": [{"key": "GLThreadedOptimizations", "value": false}]}
              ]
            }
          '';
          "nvidia/nvidia-application-profiles-rc.d/niri-wayland".text = ''
            {
              "rules": [
                  {"pattern": {"feature": "procname", "matches": "niri"}, "profile": "Limit Free Buffer Pool"}
              ],
              "profiles": [
                  {"name": "Limit Free Buffer Pool", "settings": [{"key": "GLVidHeapReuseRatio", "value": 0}]}
              ]
            }
          '';
        };
      };
    };

  flake.modules.nixos.nvidia-pro-prime =
    {
      config,
      lib,
      ...
    }:
    {
      hardware.nvidia = {
        powerManagement = {
          enable = true;
          kernelSuspendNotifier =
            config.hardware.nvidia.open && lib.versionAtLeast config.hardware.nvidia.package.version "595";
        };
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
            offloadCmdMainProgram = "prime-run";
          };
          amdgpuBusId = "PCI:35:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      environment.sessionVariables.GAMEMODERUNEXEC = "prime-run";
    };
}
