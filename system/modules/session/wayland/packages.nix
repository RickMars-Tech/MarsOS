{ pkgs, ... }:

{

    environment.systemPackages = with pkgs; [
        # Terminal
        alacritty
        foot
        zellij
        # Hyprland
        #hyprland-protocols
        #hyprcursor # The hyprland cursor format, library and utilitie
        #hyprpicker # Wlroots-compatible Wayland color picker that does not suck
        #hyprpolkitagent
        # Notification Deamon
        dunst
        libnotify
        notify
        # Wallpaper
        hyprpaper
        # App-Launcher
        fuzzel
        # Applets
        # Screen-Locker
        wlogout
        # Brightnes Manager
        brightnessctl
        # Clipboard-specific
        wl-clipboard-rs
        clapboard
        # Screenshot
        grimblast # Taking
        slurp # Selcting
        swappy # Editing
        #= Polkit
        polkit
        polkit_gnome
        # Image Viewer
        imv
        # XWayland/Wayland
        glfw
        wlr-randr
        wlroots
        wayland-utils
        xwayland
        #xwayland-run
        xwayland-satellite
    ];

}
