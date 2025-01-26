{ pkgs, ... }:
{

  stylix = {
    targets = {
      alacritty.enable = true;
      fuzzel.enable = true;
      fzf.enable = true;
    };
    iconTheme = {
      enable = true;
      package = pkgs.cosmic-icons;
      dark = "Cosmic";
    };
  };

}
