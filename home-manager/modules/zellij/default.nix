{ ... }: {

    programs.zellij = {
        enable = true;
        enableFishIntegration = true;
    };

    xdg.configFile = {
        "zellij/config.kdl".source = ./config.kdl;
        "zellij/layouts" = {
            source = ./layouts;
            recursive = true;
        };
        "zellij/plugins" = {
            source = ./plugins;
            recursive = true;
        };
    };

}
