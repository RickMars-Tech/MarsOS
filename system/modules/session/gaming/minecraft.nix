{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = [
        ffmpeg
        glfw3-minecraft
      ];
      jdks = [
        # = Java Runtimes
        graalvm-ce
        zulu
        zulu8
        zulu17
      ];
      gamemodeSupport = true;
    })
    minetest # Minecraft Like Game
  ];
}
