{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./minecraft.nix
    ./packages.nix
    ./steam.nix
  ];
  options.mars.gaming = {
    enable = lib.mkEnableOption "Gaming Config";
    gamemode = lib.mkEnableOption "Feral Gamemode";
  };

  config = let
    cfg = config.mars.gaming;
  in {
    #=> Gamemode
    programs.gamemode =
      lib.mkIf (
        cfg.enable
        == true
        && cfg.gamemode == true
      ) {
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
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
          };
        };
      };
  };
}
