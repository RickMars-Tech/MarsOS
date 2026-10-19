# Remember, PRO is not for Professional, it is for Privative
{
  flake.modules.nixos.nvidia-pro =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # nvidia_uvm (memoria unificada de CUDA) intenta mapear toda la VRAM de la
      # GPU (6GB) en el vmemmap; con solo 8GB de RAM eso falla y genera un
      # "page allocation failure" (warn_alloc) en el journal al enumerar la GPU
      # (p. ej. gfxtest de Firefox). No se usa CUDA aquí, así que se neutraliza
      # su carga. No afecta a juegos, nvidia_drm ni NVENC.
      boot.extraModprobeConfig = ''
        install nvidia-uvm ${pkgs.coreutils}/bin/true
      '';

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
        moduleParams.nvidia = lib.mkMerge [
          {
            # https://github.com/ventureoo/nvidia-tweaks#resizable-bar
            NVreg_EnableResizableBar = 1;
            # https://github.com/ventureoo/nvidia-tweaks#common-tweaks
            # NVreg_UsePageAttributeTable = 1;
            # https://github.com/ventureoo/nvidia-tweaks#wayland--nvidia
            NVreg_PreserveVideoMemoryAllocations = lib.mkForce (
              if config.hardware.nvidia.prime.offload.enable || config.hardware.nvidia.prime.sync.enable then
                0
              else
                1
            );
          }
          # https://github.com/ventureoo/nvidia-tweaks#common-tweaks
          (lib.mkIf (lib.versionOlder config.hardware.nvidia.package.version "530") {
            NVreg_RegistryDwords = "PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x1";
          })
        ];
        branch = "latest";
        # Exameple of custom version of Driver
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "615.71.09";
        #   sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
        #   sha256_aarch64 = "sha256-IbekQhE7cFfmnPZaLY9NDYcF7CoNZ+2Qb7sRd4EOgWM=";
        #   openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
        #   settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
        #   persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
        # };
      };

      environment = {
        systemPackages = with pkgs; [
          dlss-swapper
          dlss-swapper-dll
        ];
        sessionVariables = {
          # https://github.com/ventureoo/nvidia-tweaks#environment-variables
          GBM_BACKEND = "nvidia-drm";
          WLR_NO_HARDWARE_CURSORS = 1;

          __GL_YIELD = "USLEEP";
          QT_QUICK_BACKEND = "software";

          # Vulkan ICD discovery (helps AppImage/Steam runtime bundles without breaking
          # applications that prefer automatic detection)
          VK_DRIVER_FILES = lib.mkDefault "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json:/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
          VK_ICD_FILENAMES = lib.mkDefault "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json:/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
        };
        etc = lib.mkMerge [
          {
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
          }
          # https://niri-wm.github.io/niri/Nvidia.html
          (lib.mkIf config.programs.niri.enable {
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
          })
        ];

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
