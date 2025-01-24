{ pkgs, ... }: {

    environment = {
        #extraInit = "~/.cargo/bin";
        pathsToLink = [ "/share/X11" "/libexec" "/share/nix-ld" ];
        sessionVariables = {
        #=> Default's
            EDITOR = "nvim";
            BROWSER = "firefox";
            TERMINAL = "alacritty";
        #=> Zed
            ZED_ALLOW_EMULATED_GPU = "1";
        #=> Enable touch-scrolling in Mozilla software
            MOZ_USE_XINPUT2 = "1";
        #=> JAVA
            _JAVA_AWT_WM_NONREPARENTING = "1";
        #=> Intel Graphics
            LIBVA_DRIVER_NAME = "i965";
        #=> Load Shared Objects Immediately
            LD_BIND_NOW = "1";
        #=> Steam
            STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
        #=> Wayland
            MOZ_ENABLE_WAYLAND = "1";
            NIXOS_OZONE_WL = "1";
            OZONE_PLATFORM = "wayland";
            QT_QPA_PLATFORM = "wayland";
            SDL_VIDEODRIVER = "wayland";
        #=> Flatpak
            FLATPAK_GL_DRIVERS = "mesa-git";
        #=> Polkit
            POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        };
    };
}
