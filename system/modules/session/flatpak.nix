{config, ...}: let
  cfg = config.stylix;
in {
  #==> Declare Flatpak Config/Packages <==#
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    #= Declare packages to install with ID of the Aplication
    packages = [
      "edu.mit.Scratch"
      "com.github.tchx84.Flatseal"
      #= Qt
      #"io.qt.Designer"
      #"io.qt.QtCreator"
    ];
    overrides = {
      global = {
        # Force Wayland by default
        /*
        Context.sockets = [
          "wayland"
          "!fallback-x11"
          "!x11"
        ];
        */

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_THEME = "${cfg.cursor.name}";
          XCURSOR_SIZE = "${toString cfg.cursor.size}";

          # Force correct theme for some GTK apps
          #GTK_THEME = "WhiteSur-Dark";
        };
      };
    };
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
}
