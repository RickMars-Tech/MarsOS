#|==< Configuration for Asus Tuf A15/16Laptop (Ryzen + Nvidia Laptop) >==|#
_: {
  imports = [
    # Include the results of the hardware scan.
    ../hardware.nix
    ../system/default.nix
  ];

  # Hostname
  networking.hostName = "rift";

  #= MarsOptions
  mars = {
    asus = {
      enable = true;
      gamemode.enable = true;
    };
    cpu.amd.enable = true;
    graphics = {
      enable = true;
      amd.enable = true;
      nvidia = {
        enable = true;
        wayland-fixes = true;
        hybrid = {
          enable = true;
          igpu = {
            vendor = "amd";
            port = null;
          };
          dgpu.port = null;
        };
      };
    };
    gaming = {
      enable = true;
      minecraft = {
        prismlauncher.enable = true;
        java.enable = true;
      };
      steam = {
        enable = true;
        openFirewall = false;
        hardware-rules = true;
      };
      extra-gaming-packages = true;
    };
  };

  system.stateVersion = "25.11";
}
