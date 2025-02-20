{pkgs, ...}: {
  stylix = {
    targets = {
      alacritty.enable = true;
      firefox = {
        enable = true;
        firefoxGnomeTheme.enable = false;
      };
      fuzzel.enable = true;
      fzf.enable = true;
      qutebrowser.enable = true;
      waybar = {
        enable = true;
        enableLeftBackColors = false;
        enableRightBackColors = false;
      };
    };
    iconTheme = {
      enable = true;
      package = pkgs.cosmic-icons;
      dark = "Cosmic";
    };
  };
}
