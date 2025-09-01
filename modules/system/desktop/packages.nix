{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  #= Imports
  GeForceInfinity = pkgs.callPackage ../../../pkgs/geforce-infinity/default.nix {};
  dlss-swapper = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper.nix {};
  dlss-swapper-dll = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper-dll.nix {};
  zink-run = pkgs.callPackage ../../../pkgs/gamingScripts/zink-run.nix {};
  #= Options
  # graphics = config.mars.graphics;
  amd = config.mars.graphics.amd;
  intel = config.mars.graphics.intel;
  nvidiaPro = config.mars.graphics.nvidiaPro;
  gaming = config.mars.gaming;
in {
  #=> Packages Installed in System Profile.
  environment.systemPackages = with pkgs;
    [
      #= Main
      #kexec-tools
      #geogebra6
      # electron
      # chromium
      # nodejs
      libreoffice
      #= FOSS Electronics Design Automation suite
      kicad-small
      #= Clamav Anti-Virus
      clamav
      clamtk
      #|==< 3D >==|#
      #blender-hip
      #= Archives/Documents
      nautilus
      kdePackages.ark
      imagemagick
      zathura
      #= Torrent
      qbittorrent
      #= Image Editors
      #gimp
      #= Video/Audio Tools
      shotcut
      #= Video Recorder
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
          obs-gstreamer
          obs-vaapi
        ];
      })
      #= Hardware Tools
      #= PC monitoring
      stacer # Linux System Optimizer and Monitoring.
      cpu-x
      s-tui
      clinfo
      glxinfo
      hardinfo2
      hwinfo
      lm_sensors
      #= Multimedia Codecs & Libs
      # H.264 encoder/decoder plugin for mediastreamer2
      mediastreamer-openh264
      # H264/AVC
      av1an
      openh264
      x264
      # H.265/HEVC
      x265
      # WebM VP8/VP9 codec SDK
      libvpx
      # Open, royalty-free, highly versatile audio codec
      libopus
      # MPEG
      lame
      # FFMPEG
      ffmpeg
      #= Wine
      bottles
    ]
    #|==< Gaming >==|#
    ++ optionals gaming.extra-gaming-packages [
      #= Gaming Scritps
      dlss-swapper
      dlss-swapper-dll
      zink-run
      #= GeForce Infinity
      GeForceInfinity
      #= Nintendo Emulators
      dolphin-emu # Gamecube/Wii/Triforce emulator for x86_64
      #= Ocarina of Time (PC port).
      #shipwright
      #= The best Game in the World
      superTuxKart
      #= Launcher for Veloren.
      airshipper
      #= Game Launchers
      lutris
      heroic

      #= Gaming utilities
      powertop
      lm_sensors
      mangohud #= Vulkan and OpenGL overlay for monitoring PC
      goverlay #= Graphical UI to help manage Linux overlays
      libstrangle #= Frame rate limiter for Linux/OpenGL
      wireshark #= Network analysis for gaming
      pkgsi686Linux.gperftools #= Required to run CS:Source
    ]
    #|==< Hardware Packages >==|#
    #= AMD/Radeon
    ++ optionals amd.enable [
      radeontop
      amdgpu_top
      lact
      vulkan-tools
    ]
    ++
    # AI/Compute packages
    optionals amd.compute.enable [
      # ROCm platform
      rocmPackages.clr

      # Development tools
      clinfo # OpenCL info
      rocmPackages.rocm-smi # ROCm system management

      # AI frameworks (examples)
      # pytorch-rocm
      # tensorflow-rocm
    ]
    ++ optionals (amd.compute.enable && amd.compute.hip) [
      # HIP runtime
      rocmPackages.hip-common
      rocmPackages.rocm-device-libs
    ]
    #= Intel
    ++ optionals intel.enable [
      intel-undervolt
      intel-gpu-tools
      libva-utils
      glxinfo
    ]
    ++ optionals intel.vulkan [vulkan-tools]
    ++ optionals (intel.generation == "arc" || intel.generation == "xe") [
      intel-compute-runtime
      clinfo
      level-zero
    ]
    #= Nvidia(Proprietary)
    ++ optionals nvidiaPro.enable [
      # nVidia Desktop tools packages
      zenith-nvidia # Top but for Nvidia
      nvidia-system-monitor-qt # GPU monitoring
      #nvtop # Terminal GPU monitor
      # Graphics utilities
      glxinfo # OpenGL info
      #nvidia-settings # NVIDIA control panel
    ]
    ++ lib.optionals nvidiaPro.vulkan [
      # Vulkan support
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ]
    ++
    # AI/Compute packages
    lib.optionals nvidiaPro.compute.enable [
      # CUDA development
      cudatoolkit

      # Monitoring and management
      #nvidia-ml-py # Python ML interface
      #nvtop # GPU monitoring

      # Development tools
      cudaPackages.nsight_compute # CUDA profiler
      cudaPackages.nsight_systems # System profiler
    ]
    ++ lib.optionals (nvidiaPro.compute.enable && nvidiaPro.compute.tensorrt) [
      # TensorRT inference
      # tensorrt
    ];

  #==< Appimages >==#
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.ffmpeg
        pkgs.imagemagick
      ];
    };
  };
}
