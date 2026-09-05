{
  flake.modules.nixos.console = {
    # console = {
    #   enable = true;
    #   earlySetup = true;
    #   keyMap = "es";
    # };
    services.kmscon = {
      enable = true;
      config = {
        hwaccel = true;
        libseat = true;
        xkb-layout = "latam";
      };
    };
  };
}
