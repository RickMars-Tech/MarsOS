{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf optionals mkEnableOption;
  mc = config.mars.gaming;
in {
  options.mars.gaming.minecraft = {
    prismlauncher.enable = mkEnableOption "Prism Launcher";
    extraJavaPackages.enable = mkEnableOption "Enable Java";
  };
  config = {
    environment.systemPackages = with pkgs;
      optionals (mc.minecraft.prismlauncher.enable && mc.enable) [
        (prismlauncher.override {
          additionalPrograms = with pkgs; [
            ffmpeg
            glfw
          ];
          jdks = optionals (mc.minecraft.extraJavaPackages.enable && mc.enable) [
            jdk8
            jdk17
          ];
          gamemodeSupport = config.programs.gamemode.enable;
        })
      ];

    #= Java =#
    programs.java = mkIf mc.enable {
      enable = true;
      package = pkgs.jdk;
      binfmt = true;
    };
  };
}
