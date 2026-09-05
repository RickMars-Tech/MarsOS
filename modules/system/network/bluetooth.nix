{
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
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

      environment.systemPackages = with pkgs; [
        iw
        wirelesstools
        wavemon
      ];
    };
}
