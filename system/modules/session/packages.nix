{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs = {
    #= Allow unfree packages
    config.allowUnfree = true;

    #= Permitted Insecure Packages
    config.permittedInsecurePackages = ["SDL_ttf-2.0.11"];

    #= Fenix (Rust).
    overlays = [inputs.rust-overlay.overlays.default]; #[inputs.fenix.overlays.default];
  };

  #=> Packages Installed in System Profile.
  environment.systemPackages = with pkgs; [
    #= Main
    cacert
    libsForQt5.ark
    nautilus
    kexec-tools
    staruml
    # geogebra6
    #webcord
    #electron
    #jq
    #qt5.qtwayland
    #qt6.qtwayland
    usbutils
    wget
    libreoffice
    #yarn
    #= FOSS Electronics Design Automation suite
    #kicad
    #= Clamav Anti-Virus
    clamav
    clamtk
    #Blender
    #= Code Editor
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
    })
    #= Octave
    octaveFull
    ghostscript
    #= Rust
    pkgs.rust-bin.stable.latest.default
    /*
      (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    */
    #rust-analyzer-nightly
    #= C/C++
    boost
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
        ]
    ))
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
    appimage-run
    gearlever
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
    # FFMPEG
    ffmpeg
    #= Wine
    # support both 32- and 64-bit applications
    wineWowPackages.staging
    samba
    bottles
  ];

  #= Terminal FileManager
  programs.yazi = {
    enable = true;
    package = pkgs.yazi; # pkgs-stable.yazi;
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
    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: [
        pkgs.ffmpeg
        pkgs.imagemagick
      ];
    };
  };
}
