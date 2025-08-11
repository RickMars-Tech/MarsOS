{pkgs, ...}: {
  #=> Packages Installed in System Profile.
  environment.systemPackages = with pkgs; [
    #= Main
    #kexec-tools
    #geogebra6
    # electron
    # chromium
    # nodejs
    libreoffice
    # onlyoffice-desktopeditors
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
    #= Drives utilities
    smartmontools # Monitoring the health of ard drives.
    caligula # User-friendly, lightweight TUI for disk imaging
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
    bottles
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
