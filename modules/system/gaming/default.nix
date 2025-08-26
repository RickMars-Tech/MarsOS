{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  asus = config.mars.asus.gamemode;
  gaming = config.mars.gaming;
in {
  imports = [
    ./amd.nix
    ./minecraft.nix
    ./nvidia.nix
    ./packages.nix
    ./steam.nix
  ];
  options.mars.gaming = {
    enable = mkEnableOption "Gaming Config" // {default = false;};
    gamemode.enable = mkEnableOption "Feral Gamemode" // {default = false;};
  };

  config = mkIf gaming.enable {
    #=> Gamemode
    programs.gamemode = mkIf (gaming.enable && gaming.gamemode.enable) {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
          inhibit_screensaver = 1;
          disable_splitlock = 1;
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
          pin_policy = "core"; # Mejor afinidad
        };
        custom = {
          start =
            if (asus.enable == true)
            then "${pkgs.asusctl}/bin/asusctl profile -p Turbo"
            else "";

          end =
            if (asus.enable == true)
            then "${pkgs.asusctl}/bin/asusctl profile -p Balanced"
            else "";
        };
      };
    };
  };
}
