{
  pkgs,
  inputs,
  ...
}: let
  turboWrap = pkgs.callPackage ./custom-packages/turbo-wrap/default.nix {};
in {
  nixpkgs = {
    #= Permitted Insecure Packages
    #config.permittedInsecurePackages = ["SDL_ttf-2.0.11"]; #"ventoy-1.1.05"];

    #= Fenix(Rust)
    overlays = [
      inputs.fenix.overlays.default
    ];
  };

  #=> Packages Installed in System Profile.
  environment.systemPackages = with pkgs; [
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
    flashprog
    pciutils
    usbutils
    #= Archives/Documents
    # nautilus
    # nautilus-open-any-terminal
    pcmanfm
    kdePackages.ark
    imagemagick
    zathura
    #= Drives utilities
    smartmontools # Monitoring the health of ard drives.
    gnome-disk-utility # Disk Manager.
    baobab # Gui app to analyse disk usage.
    woeusb # Flash OS images for Windows.
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

  #|==> Declarate Programs <==|#

  programs = {
    #==< Git >==#
    git = {
      enable = true;
      package = pkgs.gitMinimal;
    };
    #==< Appimages >==#
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
