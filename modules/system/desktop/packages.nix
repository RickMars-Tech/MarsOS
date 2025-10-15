{pkgs, ...}: {
  #= Misc Packages
  environment.systemPackages = with pkgs; [
    libreoffice
    onlyoffice-desktopeditors
    #= Archives/Documents
    nautilus
    kdePackages.ark
    imagemagick
    #= Torrent
    qbittorrent
    #= Image Editors
    gimp
    #= Video Recorder
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
        # obs-gstreamer
        obs-vaapi
      ];
    })
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
