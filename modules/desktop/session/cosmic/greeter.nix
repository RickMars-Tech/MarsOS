{
  flake.modules.nixos.cosmic_greeter = {
    services.displayManager.cosmic-greeter.enable = true;
  };
}
