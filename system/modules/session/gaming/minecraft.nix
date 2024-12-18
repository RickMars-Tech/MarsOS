{ pkgs, ... }: {

    environment.systemPackages = with pkgs; [
        glfw3-minecraft
        (prismlauncher.override {
            jdks = [ #= Java Versions
                jdk17
                jdk8
            ];
            gamemodeSupport = true;
        })
        minetest # Minecraft Like Game
    ];

}
