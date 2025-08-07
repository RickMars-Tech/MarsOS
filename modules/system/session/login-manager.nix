{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  font = config.stylix.fonts;
  cursor = config.stylix.cursor;
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
  # services.cage.enable = true;

  programs.regreet = {
    enable = true;
    # cageArgs = ["-s"];
  };

  services.greetd = {
    enable = true;
    settings.default_session.user = "greeter";
  };

  #= TTY
  console = {
    earlySetup = true;
    keyMap = "us"; # "la-latin1";
    packages = with pkgs; [nerd-fonts.terminess-ttf];
  };
}
