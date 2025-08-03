{
  config,
  pkgs,
  lib,
  ...
}: {
  options.mars.gaming.minecraft = {
    prismlauncher.enable = lib.mkEnableOption "Prism Launcher";
    java.enable = lib.mkEnableOption "Enable Java";
  };
  config = let
    cfg = config.mars.gaming;
  in {
    environment.systemPackages = with pkgs;
      lib.mkIf (cfg.minecraft.prismlauncher.enable && cfg.enable) [
        (prismlauncher.override {
          additionalPrograms = with pkgs; [
            ffmpeg
            glfw
            #glfw3-minecraft
          ];
          jdks =
            # lib.mkIf (cfg.minecraft.java.enable && cfg.enable)
            [
              # = Java Runtimes
              jdk
              jdk8
              jdk17
            ];
          gamemodeSupport = true;
        })
        # minetest # Minecraft Like Game
      ];

    #= Java =#
    programs.java = {
      enable = cfg.minecraft.java.enable && cfg.enable;
      package = pkgs.jdk;
      binfmt = true;
    };
  };
}
