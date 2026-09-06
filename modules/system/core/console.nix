{
  flake.modules.nixos.console = {
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
