{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  imports = [
    ./amd.nix
    ./nvidiaPro.nix
    ./nvidiaFree.nix
    ./intel.nix
  ];

  options.mars.graphics.enable = mkEnableOption "Enable graphics" // {default = true;};

  config = mkIf (config.mars.graphics.enable) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
