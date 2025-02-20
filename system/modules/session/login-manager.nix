{pkgs, ...}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  #hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
in {
  #= UWSM (Universal Wayland Session Manager).
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  #==> TuiGreet <==#

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-session --asterisks"; # --sessions ${hyprland-session}";
        user = "greeter";
      };
    };
    vt = 1;
  };

  #= TTY
  console = {
    earlySetup = true;
    keyMap = "us"; # "la-latin1";
    packages = with pkgs; [nerd-fonts.terminess-ttf];
  };
}
