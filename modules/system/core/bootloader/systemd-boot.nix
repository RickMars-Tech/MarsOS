{
  flake.modules.nixos.systemd-boot = {
    boot.loader.systemd-boot = {
      enable = true;
      memtest86.enable = true;
      configurationLimit = null;
    };
  };
}
