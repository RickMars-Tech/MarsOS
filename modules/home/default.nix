{
  imports = [
    ./browser
    ./development
    ./gaming
    ./media
    ./session
    ./terminal
    ./fonts.nix
    ./miscPkgs.nix
    ./printers.nix
  ];

  # Assets & Wallpapers
  home.file = {
    "wallpapers" = {
      source = ../../assets/wallpapers;
      recursive = true;
    };
    ".face".source = ../../assets/profile.jpg;
  };
}
