{pkgs, ...}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  niri-session = "${pkgs.niri}/bin/niri";
in {
  #|==< UWSM >==|#
  programs.uwsm = {
    enable = true;
    waylandCompositors.niri = {
      prettyName = "Niri";
      comment = "Scrollable-tiling Wayland compositor";
      binPath = niri-session;
    };
  };

  #|==< TuiGreet >==|#
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --asterisks --container-padding 2 --no-xsession-wrapper";
        user = "greeter";
      };
    };
  };
}
