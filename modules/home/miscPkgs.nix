{pkgs, ...}: {
  # Misc Packages
  environment.systemPackages = with pkgs; [
    qbittorrent-enhanced
    libreoffice
    yt-dlp
  ];

  programs = {
    # Appimages
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
    # Open source alternative to AirDrop
    localsend.enable = true;
  };
}
