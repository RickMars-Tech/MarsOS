{ ... }: {

    boot = {
        loader = {
            systemd-boot = {
                enable = true;
                editor = true;
                consoleMode = "keep";
                configurationLimit = 20;
            };
            efi.canTouchEfiVariables = true;
            timeout = 3;
        };
        initrd = {
            enable = true;
            compressor = "zstd";
            verbose = true;
        };
        tmp = {
            tmpfsSize = "100%";
            useTmpfs = true;
        };
    };
}
