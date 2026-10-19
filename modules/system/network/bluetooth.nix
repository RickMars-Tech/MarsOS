{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          Experimental = false;
          FastConnectable = false;
        };
      };
    };
  };
}
