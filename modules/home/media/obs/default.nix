{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
in {
  environment.systemPackages = with pkgs;
    optionals (config.mars.multimediaSoftware) [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
          # obs-gstreamer
          obs-vaapi
        ];
      })
    ];
}
