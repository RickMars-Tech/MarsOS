{ pkgs, inputs, ... }: {

#= Allow unfree packages
  nixpkgs.config.allowUnfree = true;

#= Permitted Insecure Packages
  nixpkgs.config.permittedInsecurePackages = [ ];

#= Fenix (Rust).
  nixpkgs.overlays = [ inputs.fenix.overlays.default ];

#=> Packages Installed in System Profile.
  environment.systemPackages = with pkgs; [
  #= Main
    aml
    alsa-lib
    alsa-plugins
    alsa-utils
    cacert
    libsForQt5.ark
    nautilus
    staruml
    # geogebra6
    #webcord
    #electron
    #jq
    qt5.qtwayland
    qt6.qtwayland
    usbutils
    wget
    libreoffice
    #yarn
  #= FOSS Electronics Design Automation suite
    #kicad
  #= Clamav Anti-Virus
    clamav
    clamtk
  #= Blender
    #blender
  #= Code Editor
    /*vscodium-fhs
    (vscode-with-extensions.override {
      vscode = vscodium-fhs;
      vscodeExtensions = with vscode-extensions; [
        catppuccin.catppuccin-vsc
        rust-lang.rust-analyzer
        supermaven.supermaven
        bbenoist.nix
        ms-python.python
        ms-python.debugpy
        ms-python.pylint
        ms-python.flake8
        ms-python.vscode-pylance
      ];
    })*/
    #zed-editor
  #= Local Lenguage Model
    #ollama
  #= Game Engine
    #godot_4
  #= Rust
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
  #= C/C++
    #boost
    cmake
    flex
    gccgo
    glib
    glibc
    glibmm
    libgcc
    ncurses
    SDL2
    SDL2_image
    SDL2_ttf
  #= Python
    (python312.withPackages (ps: with ps; [
      anyqt
      pyqtdarktheme
      qtawesome
      qtpy
      pyqt6
      py
      pipx
      pydevd
      pyls-isort
      pylint
      pylint-venv
      pylint-plugin-utils
      python-lsp-server
      pytest
      pygame
    ]))
    kdePackages.qttools
  #= XDG
    xdg-utils
    xdg-launch
    xdg-user-dirs
  #= Cli Utilities
    any-nix-shell
    bat
    eza
    curl
    wget
    flashprog
    fzf
    trash-cli
    nerdfetch
    git
    gitoxide
    bottom
    lynx
    macchanger
    pciutils
    ripgrep
    skim
    zoxide
    #uutils-coreutils-noprefix
    #busybox
    woeusb
  #= Archives
    imagemagick
    zip
    unzip
    gnutar
    #rarcrack
    rar
    unrar-free
  #= Drives utilities
    smartmontools # Monitoring the health of ard drives.
    gnome-disk-utility # Disk Manager.
    baobab # Gui app to analyse disk usage.
    ventoy # Flash OS images for Linux and anothers Systems.
    woeusb # Flash OS images for Windows.
  #= Flatpak
    libportal
    libportal-gtk3
    libportal-gtk4
    libportal-qt5
  #= Appimages
    #appimagekit
    appimage-run
    gearlever
  #= Torrent
    qbittorrent
  #= Image Editors
    #krita
    gimp
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
    # PNG
    libpng
    # JPEG
    libjpeg
    # FFMPEG
    ffmpeg
  #= Wine
    bottles
  ];

#= Terminal FileManager
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;#pkgs-stable.yazi;
    settings.yazi = {
      manager = {
        sort_by = "natural";
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        image_filter = "lanczos3";
        image_quality = 60;
        max_width = 600;
        max_height = 900;
        ueberzug_scale = 1;
        ueberzug_offset = [0 0 0 0];
      };
      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };
    };
  };

#= Java =#
  programs.java = {
    enable = true;
    package = pkgs.jdk;
    binfmt = true;
  };

#==> Appimages <==#
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
