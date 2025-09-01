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
    ./minecraft.nix
    ./steam.nix
  ];
  options.mars.gaming = {
    enable = mkEnableOption "Gaming Config" // {default = false;};
    gamemode = {
      enable = mkEnableOption "Feral Gamemode" // {default = false;};
      nvidiaOptimizations = mkEnableOption "nVidia Gamemode"; #= Configs on desktop/env.nix
      amdOptimizations = mkEnableOption "AMD Gamemode";
    };
    extra-gaming-packages = mkEnableOption "Some Extra Games/Packages";
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
        gpu = mkIf (gaming.gamemode.amdOptimizations && gaming.enable) {
          amd_performance_level = "high";
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };
        filter.whitelist = "steam";
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
