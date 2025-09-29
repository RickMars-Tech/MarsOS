{config, ...}: let
  wall = config.stylix.image;
in {
  services.wpaperd = {
    enable = true;
    settings.any.path = wall;
  };
}
