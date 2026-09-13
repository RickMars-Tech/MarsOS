# Remember, PRO is not for Professional, it is for Privative
{
  flake.modules.nixos.nvidia-pro =
    { config, pkgs, ... }:
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
        nvidiaSettings = true;
        modesetting.enable = true;
        dynamicBoost.enable = true;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
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
