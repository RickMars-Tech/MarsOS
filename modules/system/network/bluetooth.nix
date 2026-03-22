{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
in {
  #= Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  environment.systemPackages = with pkgs;
    optionals config.hardware.bluetooth.enable [
      iw
      wirelesstools
      wavemon
    ];
}
