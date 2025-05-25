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
      wpaperd.enable = true;
      swaylock.enable = true;
      fuzzel.enable = false;
      helix.enable = false;
      rio.enable = false;
      vscode.enable = false;
      fzf.enable = true;
      qutebrowser.enable = true;
      waybar = {
        enable = true;
        addCss = true;
        #font = "monospace";
        enableLeftBackColors = false;
        enableRightBackColors = false;
      };
    };
    iconTheme = {
      enable = true;
      package = pkgs.reversal-icon-theme;
      dark = "Reversal";
      light = "Reversal";
    };
  };
}
