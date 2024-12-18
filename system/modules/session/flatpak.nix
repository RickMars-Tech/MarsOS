{ ... }: {

#==> Declare Flatpak Config/Packages <==#

    services.flatpak = {
        enable = true;
        remotes = [{
            name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }];
    #= Declare packages to install with ID of the Aplication
        packages = [
            "io.github.hmlendea.geforcenow-electron"
            "io.github.thetumultuousunicornofdarkness.cpu-x"
            #"com.boxy_svg.BoxySVG"
            "com.github.tchx84.Flatseal"
            #= Qt IDE's
            #"io.qt.Designer"
            #"io.qt.QtCreator"

        ];
        overrides = {
            global = {
            # Force Wayland by default
                Context.sockets = ["wayland" "!x11" "!fallback-x11"];

                Environment = {
                    # Fix un-themed cursor in some Wayland apps
                    XCURSOR_THEME = "Bibata-Modern-Classic";
                    XCURSOR_SIZE = "24";

                    # Force correct theme for some GTK apps
                    GTK_THEME = "WhiteSur-Dark";
                };
            };
        };
        update.onActivation = true;
        uninstallUnmanaged = true;
    };

}
