{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.mars.gaming.minecraft = {
    prismlauncher.enable = mkEnableOption "Prism Launcher";
    extraJavaPackages.enable = mkEnableOption "Enable Java";
  };
  config = let
    cfg = config.mars.gaming;
  in {
    environment.systemPackages = with pkgs;
      mkIf (cfg.minecraft.prismlauncher.enable && cfg.enable) [
        (prismlauncher.override {
          additionalPrograms = with pkgs; [
            ffmpeg
            glfw
          ];
          jdks =
            # (mkIf (cfg.minecraft.extraJavaPackages && cfg.enable))
            [
              # = Java Runtimes
              jdk
              jdk8
              jdk17
            ];
          gamemodeSupport = config.programs.gamemode.enable;
        })
      ];

    #= Java =#
    programs.java = {
      enable = true;
      package = pkgs.jdk;
      binfmt = true;
    };
  };
}
