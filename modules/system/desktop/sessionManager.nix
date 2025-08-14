{pkgs, ...}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
in {
  #==< TuiGreet >==#
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --asterisks --container-padding 2 --no-xsession-wrapper --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
