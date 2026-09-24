{
  flake.modules.nixos.powerManagement = { config, ... }: {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = !config.services.desktopManager.cosmic.enable;
    };
  };
}
