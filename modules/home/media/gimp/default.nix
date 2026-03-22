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
      gimp
    ];
}
