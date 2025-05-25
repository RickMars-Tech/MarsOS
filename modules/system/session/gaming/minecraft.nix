{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      additionalPrograms = with pkgs; [
        ffmpeg
        #glfw3-minecraft
      ];
      jdks = [
        # = Java Runtimes
        jdk
        jdk8
        jdk17
      ];
      gamemodeSupport = true;
    })
    minetest # Minecraft Like Game
  ];
}
