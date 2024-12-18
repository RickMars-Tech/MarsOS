{ config, ... }: {

    home.file.steam-slow-fix = {
        enable = true;
        text = ''
            @nClientDownloadEnableHTTP2PlatformLinux 0
            @fDownloadRateImprovementToAddAnotherConnection 1.0
            unShaderBackgroundProcessingThreads 4
        '';
        target = "${config.xdg.dataHome}/Steam/steam_dev.cfg";
    };
}
