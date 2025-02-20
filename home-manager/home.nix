{
  config,
  username,
  ...
}: {
  imports = [
    ./modules/default.nix
    ./hm-stylix.nix
  ];

  #= Home-Manager
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    enableNixpkgsReleaseCheck = true;
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;

  #= XDG
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_BACKUP_DIR = "${config.xdg.userDirs.documents}/Backup";
        XDG_GAMES_DIR = "${config.home.homeDirectory}/Games";
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };

  #= Wallpapers
  home.file."wal" = {
    source = ./wal;
    recursive = true;
  };
}
