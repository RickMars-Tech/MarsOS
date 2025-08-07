{
  config,
  username,
  pkgs,
  ...
}: let
  home = config.home.homeDirectory;
in {
  imports = [
    ./modules/default.nix
    ./stylix.nix
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

  #= XDG
  xdg = {
    enable = true;
    autostart.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      #= Directories
      download = "${home}/Downloads";
      desktop = "${home}/Desktop";
      documents = "${home}/Documents";
      music = "${home}/Music";
      pictures = "${home}/Pictures";
      videos = "${home}/Videos";
      templates = "${home}/Templates";
      publicShare = "${home}/Public";
      extraConfig = {
        XDG_BACKUP_DIR = "${home}/Backup";
        XDG_GAMES_DIR = "${home}/Games";
        XDG_SCREENSHOTS_DIR = "${home}/Pictures/Screenshots";
      };
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "gtk";
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/pdf" = "zathura.desktop";
        "text/markdown" = "hx.desktop";
        "text/plain" = "hx.desktop";
        "text/x-shellscript" = "hx.desktop";
        "text/x-python" = "hx.desktop";
        "text/x-go" = "hx.desktop";
        "text/css" = "hx.desktop";
        "text/javascript" = "hx.desktop";
        "text/x-c" = "hx.desktop";
        "text/x-c++" = "hx.desktop";
        "text/x-java" = "hx.desktop";
        "text/x-rust" = "hx.desktop";
        "text/x-yaml" = "hx.desktop";
        "text/x-toml" = "hx.desktop";
        "text/x-dockerfile" = "hx.desktop";
        "text/x-xml" = "hx.desktop";
        "text/x-php" = "hx.desktop";
        "image/png" = "imv-dir.desktop";
        "image/jpg" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "image/gif" = "imv-dir.desktop";
        "image/svg" = "imv-dir.desktop";
        "image/tiff" = "imv-dir.desktop";
        "video/avi" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mkv" = "mpv.desktop";
      };
    };
  };

  #= Wallpapers
  home.file = {
    "wallpapers" = {
      source = ../../assets/wallpapers;
      recursive = true;
    };
    ".face" = {
      source = ../../assets/usr.png;
    };
    ".face.icon" = {
      source = ../../assets/usr.png;
    };
  };
}
