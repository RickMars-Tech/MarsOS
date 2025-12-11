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
    stateVersion = "26.05";
  };

  #= Assets & Wallpapers
  home.file."wallpapers" = {
    source = ../../assets/wallpapers;
    recursive = true;
  };
}
