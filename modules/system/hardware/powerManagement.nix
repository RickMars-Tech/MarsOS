{
  flake.modules.nixos.power = {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true;
    };
  };
}
