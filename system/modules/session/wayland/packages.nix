{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Terminal
    #ghostty # <-- already defined on Home-Manager hm/mdls/ghostty
    #alacritty
    # Hyprland
    hyprland-protocols
    hyprcursor # The hyprland cursor format, library and utilitie
    hyprpicker # Wlroots-compatible Wayland color picker that does not suck
    hyprpolkitagent
    hyprpaper
    hyprland-qt-support
    hyprland-qtutils
    # Status Bar
    waybar
    # Notification Deamon
    dunst
    libnotify
    notify
    # App-Launcher
    fuzzel
    rofi-wayland-unwrapped
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
    soteria
    #polkit_gnome
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
    xcb-util-cursor
    xorg.libxcb
  ];
}
