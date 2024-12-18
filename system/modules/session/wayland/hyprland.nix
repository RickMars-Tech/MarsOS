{ pkgs, inputs, ... }: {

    programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        systemd.setPath.enable = true;
        xwayland.enable = true;
    };

    #= Hyprlock
    programs.hyprlock.enable = true;

    #= Hypridle
    services.hypridle.enable = true;

    #==> Hyprland Packages Needed
    environment.systemPackages = with pkgs; [
        # Terminal
        foot
        zellij
        # Hyprland
        hyprland-protocols
        hyprcursor # The hyprland cursor format, library and utilitie
        hyprpicker # Wlroots-compatible Wayland color picker that does not suck
        #cage
        # Notification Deamon
        dunst
        libnotify
        notify
        # Wallpaper
        hyprpaper
        # App-Launcher
        rofi-wayland
        # Applets
        # Screen-Locker
        wlogout
        # Brightnes Manager
        brightnessctl
        # Clipboard-specific
        wl-clipboard-rs
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
        xwaylandvideobridge
    ];
}
