{
  flake.modules.nixos.theme =
    {
      username,
      pkgs,
      ...
    }:
    let
      theme-name = "adw-gtk3-dark";
      icon-theme-name = "WhiteSur-dark"; # "MacTahoe-dark";

      gtkSettings2 = ''
        include "~/.gtkrc-2.0.mine"
        gtk-theme-name=${theme-name}
        gtk-icon-theme-name=${icon-theme-name}
        gtk-font-name="Montserrat Medium 11"
        gtk-cursor-theme-name="Bibata-Modern-Classic"
        gtk-cursor-theme-size=24
        gtk-toolbar-style=GTK_TOOLBAR_ICONS
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=0
        gtk-menu-images=0
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=0
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';

      gtkSettings3 = ''
        [Settings]
        gtk-theme-name=${theme-name}
        gtk-icon-theme-name=${icon-theme-name}
        gtk-font-name=Montserrat Medium 11
        gtk-cursor-theme-name=Bibata-Modern-Classic
        gtk-cursor-theme-size=24
        gtk-toolbar-style=GTK_TOOLBAR_ICONS
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=0
        gtk-menu-images=0
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=0
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
        gtk-application-prefer-dark-theme=1
      '';

      gtkSettings4 = ''
        [Settings]
        gtk-theme-name=${theme-name}
        gtk-icon-theme-name=${icon-theme-name}
        gtk-font-name=Montserrat Medium 11
        gtk-cursor-theme-name=Bibata-Modern-Classic
        gtk-cursor-theme-size=24
        gtk-application-prefer-dark-theme=1
      '';
    in
    {
      programs.dconf.enable = true;

      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "adwaita-dark";
      };

      environment = {
        sessionVariables = {
          GTK_THEME = theme-name;
          XDG_ICON_DIR = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur";
          GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
          XCURSOR_THEME = "Bibata-Modern-Classic";
          XCURSOR_SIZE = "20";
          QS_ICON_THEME = icon-theme-name;
        };

        systemPackages = with pkgs; [
          bibata-cursors
          (whitesur-icon-theme.override {
            boldPanelIcons = true;
            alternativeIcons = true;
          })
          gsettings-desktop-schemas
          adw-gtk3
          nwg-look
          gtk3
          gtk4
        ];
      };

      # Archivos del usuario vía hjem
      hjem.users.${username}.files = {
        "gtkrc-2.0".text = gtkSettings2;
        ".config/gtk-3.0/settings.ini".text = gtkSettings3;
        ".config/gtk-3.0/gtk.css".text = ''
          @import url("noctalia.css");
        '';

        ".config/gtk-4.0/settings.ini".text = gtkSettings4;
        ".config/gtk-4.0/gtk.css".text = ''
          @import url("noctalia.css");
          @import url('libadwaita.css');
          @import url('libadwaita-tweaks.css');
        '';
        ".config/gtk-4.0/libadwaita.css".text = "";
        ".config/gtk-4.0/libadwaita-tweaks.css".text = "";

        ".config/gtk-3.0/bookmarks".text = ''
          file:///home/${username}/Documents Documents
          file:///home/${username}/Downloads Downloads
          file:///home/${username}/Music Music
          file:///home/${username}/Pictures Pictures
          file:///home/${username}/Videos Videos
          file:///home/${username}/Games Games
        '';
      };
    };
}
