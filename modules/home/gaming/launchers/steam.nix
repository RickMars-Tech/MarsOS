{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault mkEnableOption;
  gaming = config.mars.gaming;
  proton-em = pkgs.callPackage ../../../../pkgs/proton-em/default.nix {};
in {
  options.mars.gaming = {
    steam = {
      enable = mkEnableOption "Enable Steam";
      openFirewall = mkEnableOption "Open Ports of Firewall dedicated for Steam";
      hardware-rules = mkEnableOption "Steam Hardware Udev Rules" // {default = false;};
    };
  };
  config = {
    programs = mkIf (gaming.enable && gaming.steam.enable) {
      steam = {
        enable = true;
        remotePlay.openFirewall = gaming.steam.openFirewall;
        dedicatedServer.openFirewall = gaming.steam.openFirewall;
        extest.enable = false;
        protontricks.enable = mkDefault false;
        # package = pkgs.steam.override {
        #   # https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-2425213386
        #   extraProfile = ''
        #     unset TZ
        #   '';
        #   privateTmp = false; # https://github.com/NixOS/nixpkgs/issues/381923
        # };
        extraCompatPackages = with pkgs; [
          (proton-ge-bin.override {
            steamDisplayName = "Proton GE";
          })
          proton-em
        ];
      };
    };

    hardware.steam-hardware.enable = gaming.steam.hardware-rules;

    environment.systemPackages = with pkgs;
      mkIf (gaming.enable && gaming.steam.enable) [
        steam-run
        protontricks
        protonplus
      ];

    xdg.dataFile."Steam/steam_dev.cfg".text = ''
      @eHTTP2PlatformLinux 0
      @nClientDownloadEnableHTTP2PlatformLinux 0
      @fDownloadRateImprovementToAddAnotherConnection 1.0
      @unShaderBackgroundProcessingThreads 6
    '';
  };
}
