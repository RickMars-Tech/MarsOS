{
  pkgs,
  inputs,
  ...
}: let
  turboWrap = pkgs.callPackage ./custom-packages/turbo-wrap/default.nix {};
in {
  nixpkgs = {
    #= Allow unfree packages
    config.allowUnfree = true;

    #= Permitted Insecure Packages
    config.permittedInsecurePackages = ["SDL_ttf-2.0.11" "ventoy-1.1.05"];

    #= Fenix(Rust)
    overlays = [
      inputs.fenix.overlays.default
    ];
  };

  #=> Packages Installed in System Profile.
  environment.systemPackages = with pkgs; [
    #= Goofy
    neo
    #= Main
    #kexec-tools
    #geogebra6
    electron
    chromium
    nodejs
    libreoffice
    onlyoffice-desktopeditors
    #= FOSS Electronics Design Automation suite
    kicad-small
    #= Clamav Anti-Virus
    #clamav
    #clamtk
    #|==< 3D >==|#
    #blender
    #|==< Dev >==|#
    #==> Arduino <==#
    arduino-core
    arduino-cli
    arduino-ide
    #==> Code <==#
    #= Rust
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
    #= Zig
    zig
    #= C/C++
    clang-tools
    libclang
    cmake
    gccgo
    glib
    glibc
    glibmm
    libgcc
    SDL2
    SDL2_image
    SDL2_ttf
    #= Python
    (python3.withPackages (
      p:
        with p; [
          anyqt
          numpy
          matplotlib
          pyqtdarktheme
          qtawesome
          pyautogui
          pyside6
          pyqt6-webengine
          py
          pygame
          #pygame-sdl2
          pyopengl
          #ruff
        ]
    ))
    #= Octave
    (octaveFull.withPackages (opkgs:
      with opkgs; [
        io
        symbolic
        video
        strings
      ]))
    ghostscript
    #= TurboWrap(Scratch3)
    turboWrap
    #= XDG
    xdg-utils
    xdg-launch
    xdg-user-dirs
    #= Cli Utilities
    any-nix-shell
    bat
    eza
    #curl
    xcp # Extended CP
    #wget
    flashprog
    trash-cli
    nerdfetch
    git
    gitoxide
    bottom
    #lynx
    macchanger
    nurl
    pciutils
    ripgrep
    skim
    usbutils
    zoxide
    woeusb
    #= Archives/Documents
    nautilus
    nautilus-open-any-terminal
    kdePackages.ark
    imagemagick
    zip
    unzip
    gnutar
    #rarcrack
    rar
    unrar-free
    zathura
    #= Drives utilities
    smartmontools # Monitoring the health of ard drives.
    gnome-disk-utility # Disk Manager.
    baobab # Gui app to analyse disk usage.
    ventoy # Flash OS images for Linux and anothers Systems.
    woeusb # Flash OS images for Windows.
    #= Appimages
    #appimage-run
    #gearlever
    #= Torrent
    qbittorrent
    #= Image Editors
    gimp
    #= Video/Audio Tools
    shotcut
    #= Video Recorder
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        #obs-vkcapture
        obs-gstreamer
        obs-vaapi
      ];
    })
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
  ];

  #= Declarate Programs
  programs = {
    #= Terminal FileManager
    yazi = {
      enable = true;
      package = inputs.yazi.packages.${pkgs.system}.default;
      settings.yazi = {
        manager = {
          sort_by = "natural";
          show_hidden = true;
          show_symlink = true;
        };
        preview = {
          image_filter = "triangle"; #"lanczos3";
          image_delay = 10;
          image_quality = 70;
          max_width = 600;
          max_height = 900;
          ueberzug_scale = 1;
          ueberzug_offset = [
            0
            0
            0
            0
          ];
        };
        tasks = {
          micro_workers = 5;
          macro_workers = 10;
          bizarre_retry = 5;
        };
      };
    };

    #= TheFuck =#
    thefuck = {
      enable = false;
      alias = "fuck";
    };

    #= Java =#
    java = {
      enable = true;
      package = pkgs.jdk;
      binfmt = true;
    };

    #==> Appimages <==#
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.ffmpeg
          pkgs.imagemagick
        ];
      };
    };
  };
}
