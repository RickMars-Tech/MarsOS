{
  pkgs,
  inputs,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  niri-session = "${pkgs.niri-unstable}/usr/local/bin/niri-session";
in {
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  #==> TuiGreet <==#
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-session --asterisks --sessions ${niri-session}";
        user = "greeter";
      };
    };
  };

  #= TTY
  console = {
    earlySetup = true;
    keyMap = "us"; # "la-latin1";
    packages = with pkgs; [nerd-fonts.terminess-ttf];
  };
}
