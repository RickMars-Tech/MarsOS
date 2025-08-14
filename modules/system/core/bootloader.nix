_: {
  boot = {
    bootspec.enable = true;
    loader = {
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
  };
}
