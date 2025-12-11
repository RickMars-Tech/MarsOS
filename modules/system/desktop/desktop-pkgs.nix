{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption optionals;
in {
  options.mars.desktop = {
    graphics = mkEnableOption "Graphics and Design Applications" // {default = false;};
  };

  config = {
    #= Misc Packages
    environment.systemPackages = with pkgs;
      [
        libreoffice
        #= Archives/Documents
        nautilus
        kdePackages.ark
      ]
      ++ optionals config.mars.desktop.graphics [
        #= Image Editor
        gimp
        #= Video Editor
        kdePackages.kdenlive
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

    programs = {
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
      #= Open source alternative to AirDrop
      localsend.enable = true;
    };
    services.qbittorrent.enable = true;
  };
}
