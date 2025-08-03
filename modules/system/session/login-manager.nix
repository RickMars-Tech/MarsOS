{
  inputs,
  pkgs,
  lib,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in {
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  #|==< UWSM >==|#
  programs.uwsm = {
    enable = true;
    waylandCompositors."niri" = {
      prettyName = "Niri";
      comment = "A scrollable-tiling Wayland compositor.";
      binPath = lib.getExe pkgs.niri-unstable;
    };
  };

  #|==< GreetD >==|#
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-session --asterisks";
        user = "greeter";
      };
    };
    vt = 1;
  };

  /*
    services.displayManager.cosmic-greeter = {
    enable = true;
  };
  */

  #= TTY
  console = {
    earlySetup = true;
    keyMap = "us"; # "la-latin1";
    packages = with pkgs; [nerd-fonts.terminess-ttf];
  };
}
