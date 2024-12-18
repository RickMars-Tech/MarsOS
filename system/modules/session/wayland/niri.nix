{ pkgs, ... }: {

    #nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    #niri-flake.cache.enable = true;
    programs.niri = {
        enable = true;
        #package = pkgs.niri-unstable;
    };

    environment.systemPackages = with pkgs; [
        #= Terminal
        #alacritty
        foot
        zellij
        gnome-keyring
        #= Terminal
        foot
        zellij
        #= Notification Deamon
        dunst
        libnotify
        notify
        #= Wallpaper
        hyprpaper
        #= App Launcher
        fuzzel # Wayland App launcher
        #= Screen Locker
        wlogout
        #= Brightnes Manager
        brightnessctl
        #= Clipboard-specific
        wl-clipboard-rs
        clapboard
        #= Polkit
        polkit
        polkit_gnome
        #= Image Viewer
        imv
        #= XWayland/Wayland
        glfw
        wlr-randr
        wlroots
        wayland-utils
        xwayland
        #xwayland-run
        xwayland-satellite
        #xwaylandvideobridge
    ];

}
