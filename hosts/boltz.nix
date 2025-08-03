#|==< Configuration for Thinkpad T420(Intel Laptop) >==|#
_: {
  imports = [
    # Include the results of the hardware scan.
    ../hardware.nix
    ../system/default.nix
  ];

  # Hostname
  networking.hostName = "boltz";

  #= MarsOptions
  mars = {
    cpu.intel.enable = true;
    graphics = {
      enable = true;
      intel.enable = true;
    };
    thinkpad.enable = true;
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
