{ ... }: {

    programs.nix-index = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = false;
        enableZshIntegration = false;
    };
}
