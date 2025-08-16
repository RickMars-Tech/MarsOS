{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      systemd-boot.enable = mkForce false; # Lanzaboote currently replaces the systemd-boot module.
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    initrd = {
      enable = true;
      compressor = "zstd";
      verbose = false;
    };
  };
  # For debugging and troubleshooting Secure Boot.
  environment.systemPackages = with pkgs; [sbctl];
}
