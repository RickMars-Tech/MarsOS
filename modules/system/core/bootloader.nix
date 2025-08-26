{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  boot = {
    #|==< Secure Boot >==|#
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      systemd-boot.enable = mkForce false; # Lanzaboote currently replaces the systemd-boot module.
      efi.canTouchEfiVariables = false;
      timeout = 5;
    };
    initrd = {
      enable = true;
      verbose = false;
      #= Compession
      compressor = "zstd";
      compressorArgs = ["-22" "-T0" "--long" "--ultra"];
    };
    consoleLogLevel = 4; # Default

    #|==< Plymouth >==|#
    plymouth = {
      enable = true;
      theme = "hexagon_dots";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = ["hexagon_dots"];
        })
      ];
    };
  };
  # For debugging and troubleshooting Secure Boot.
  environment.systemPackages = with pkgs; [sbctl];
}
