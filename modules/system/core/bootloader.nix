{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.mars.boot = {
    secureBoot = mkEnableOption "Enable Secure Boot";
    plymouth = mkEnableOption "Enable Plymouth";
  };
  config = {
    boot = {
      # Secure Boot (NOT Recomended)
      lanzaboote = {
        enable = config.mars.boot.secureBoot;
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          includeMicrosoftKeys = true;
          autoReboot = true;
        };
        pkiBundle = "/var/lib/sbctl";
      };
      loader = {
        systemd-boot = {
          enable = !config.mars.boot.secureBoot;
          memtest86.enable = true;
        };
        efi.canTouchEfiVariables = false;
        timeout = 5;
      };
      initrd = {
        enable = true;
        verbose = false;
        compressor = "zstd";
        compressorArgs = ["-10" "-T0"];
      };
      consoleLogLevel = 3;

      # Plymouth
      plymouth.enable = config.mars.boot.plymouth;
    };
    # For debugging and troubleshooting Secure Boot
    environment.systemPackages = with pkgs; mkIf config.mars.boot.secureBoot [sbctl];
  };
}
