{
  inputs,
  pkgs,
  ...
}: let
  anyrun = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;
in {
  imports = [./cssConfig.nix];
  programs.anyrun = {
    enable = true;
    package = anyrun;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        dictionary
        symbols
        websearch
      ];
      layer = "overlay";
      ignoreExclusiveZones = false;
      width.fraction = 0.3;
      y.absolute = 35;
      hidePluginInfo = true;
      closeOnClick = true;
    };
  };
}
