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
        timezone
        user
      ];

      environment = {
        systemPackages = with pkgs; [
          libreoffice
          qbittorrent-enhanced
          gsettings-desktop-schemas
        ];

        # Permite que gsettings encuentre los esquemas GLib (org.gnome.desktop.*),
        # usados p. ej. por cosmic-session para aplicar el tema oscuro de GTK.
        sessionVariables.XDG_DATA_DIRS = [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
        ];
      };

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
    };
}
