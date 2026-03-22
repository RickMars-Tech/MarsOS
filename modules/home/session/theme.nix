{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      bibata-cursors
      (whitesur-icon-theme.override {
        boldPanelIcons = true;
        alternativeIcons = true;
      })
      gsettings-desktop-schemas
    ];
    sessionVariables = {
      XDG_ICON_DIR = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur";
      GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "20";
      QS_ICON_THEME = "WhiteSur";
    };
  };
  qt = {
    enable = true;
    platformTheme = "qt5ct"; # Qt5 & Qt6
    style = "adwaita-dark";
  };
}
