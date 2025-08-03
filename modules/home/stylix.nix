{pkgs, ...}: {
  stylix = {
    targets = {
      firefox = {
        enable = true;
        profileNames = [
          "default"
        ];
        firefoxGnomeTheme.enable = false;
      };
      hyprlock.enable = false;
      fuzzel.enable = false;
      helix.enable = false;
      fzf.enable = true;
      wezterm.enable = false;
    };
    iconTheme = {
      enable = true;
      package = pkgs.whitesur-icon-theme.override {
        boldPanelIcons = true;
        alternativeIcons = true;
      };
      dark = "WhiteSur";
      light = "WhiteSur";
      # package = pkgs.reversal-icon-theme;
      # dark = "Reversal";
      # light = "Reversal";
    };
  };
}
