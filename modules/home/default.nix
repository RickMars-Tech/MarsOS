{username, ...}: {
  imports = [
    ./common/default.nix
    ./windowManager/default.nix
    ./xdg.nix
  ];

  #= Home-Manager
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    preferXdgDirectories = true; #= Make programs use XDG directories
    enableNixpkgsReleaseCheck = true;
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;

  #= Assets & Wallpapers
  home.file = {
    "wallpapers" = {
      source = ../../assets/wallpapers;
      recursive = true;
    };
    ".face.icon" = {
      source = ../../assets/usr.png;
    };
  };
}
