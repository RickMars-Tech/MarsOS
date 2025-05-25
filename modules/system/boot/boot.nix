_: {
  boot = {
    bootspec.enable = true;
    loader = {
      /*
      limine = {
        enable = true;
        efiSupport = true;
        enableEditor = true;
        maxGenerations = 10;
      };
      */
      systemd-boot = {
        enable = true;
        editor = true;
        consoleMode = "auto";
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    initrd = {
      enable = true;
      compressor = "zstd";
      verbose = false;
    };
    tmp.cleanOnBoot = true;
  };
}
