{
  flake.modules.nixos.power = { config, ... }: {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = (!config.hardware.system76.power-daemon.enable);
    };
  };
}
