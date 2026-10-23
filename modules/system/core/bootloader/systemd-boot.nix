{
  flake.modules.nixos.systemd-boot = {
    boot.loader.systemd-boot = {
      enable = true;
      memtest86.enable = true;
      # ESP de 1 GB: limitar generaciones evita llenarla.
      configurationLimit = 10;
    };
  };
}
