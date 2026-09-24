{
  flake.modules.nixos.desktop =
    {
      self,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        media
        terminal
        printers
        session
        user
      ];

      environment.systemPackages = with pkgs; [
        libreoffice
        qbittorrent-enhanced
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
        fuse.enable = true;
        # Open source alternative to AirDrop
        localsend.enable = true;
      };

      services.dbus = {
        enable = true;
        implementation = "broker";
        # packages = with pkgs; [
        #   nautilus
        #   xdg-desktop-portal
        #   xdg-desktop-portal-gnome
        # ];
      };
    };
}
