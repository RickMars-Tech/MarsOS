{ config, pkgs, username, ... }: {

    imports = [
        ./modules/default.nix
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

#= DCONF
    dconf = {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

#= CURSOR
    home.pointerCursor = {
        gtk.enable = true;
        #x11.enable = true;
        package = pkgs.apple-cursor;#pkgs.bibata-cursors;
        name = "macOS";#"Bibata-Original-Classic";
        size = 24;
    };

#= GTK
    gtk = {
        enable = true;
        theme = {
            package = pkgs.whitesur-gtk-theme; #pkgs.material-black-colors;
            name = "WhiteSur-Dark"; #"Material-Black-Blueberry";
        };
        iconTheme = {
            package = pkgs.cosmic-icons; #pkgs.flat-remix-icon-theme;
            name = "Cosmic"; #"Flat-Remix-Blue-Dark";
        };
    };

#= QT
    qt = {
        enable = true;
        platformTheme.name = "gtk";
        style = {
            package = pkgs.adwaita-qt;
            name = "adwaita-dark";
        };
    };
}
