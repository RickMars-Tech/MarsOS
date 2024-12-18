{ pkgs, ... }: let
  
    tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
    niri-session = "${pkgs.niri}/share/wayland-sessions";
    #hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";

in {

#==> Ly <==#
    /*services.displayManager.ly = {
        enable = true;
        settings = {
            animation = "matrix";
            hide_borders = true;
            save = true;
        };
    };*/

#==> Greetd <==#
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${tuigreet} --time --remember --remember-session --asterisks --sessions ${niri-session}";
                user = "greeter";
            };
        };
        vt = 1;
    };

#= TTY
    console = {
        earlySetup = true;
        keyMap = "us"; #"la-latin1";
        packages = with pkgs; [ nerd-fonts.terminess-ttf ];
    };

}
