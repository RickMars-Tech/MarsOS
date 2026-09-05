{
  flake.modules.nixos.greeter =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {

      services.displayManager.noctalia-greeter = {
        enable = true;
        settings = {
          output.scale = 1.0;
          cursor = {
            theme = config.environment.sessionVariables.XCURSOR_THEME;
            size = lib.toInt config.environment.sessionVariables.XCURSOR_SIZE;
            package = pkgs.bibata-cursors;
          };
          keyboard.layout = "latam";
        };
        package = pkgs.noctalia-greeter;
      };
    };
}
