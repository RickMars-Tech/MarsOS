{
  flake.modules.nixos.power = { config, ... }: {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = !config.services.desktopManager.cosmic.enable;
    };
  };
}
