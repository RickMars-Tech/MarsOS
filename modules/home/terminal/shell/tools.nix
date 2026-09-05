{
  flake.modules.nixos.shellTools =
    {
      config,
      pkgs,
      ...
    }:
    {
      programs = {
        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batman
            prettybat
          ];
        };
        skim = {
          enable = true;
        };
        zoxide = {
          enable = true;
          flags = [
            "--no-cmd"
            "--cmd cd"
          ];
          enableFishIntegration = config.programs.fish.enable;
          enableBashIntegration = config.programs.bash.enable;
        };
      };
      # Shell/CLI programs
      environment.systemPackages = with pkgs; [
        # eza # Replacement for ls
        # xcp # Extended CP
        # dust # Like du but more intuitive
        # duf # Disk Usage/Free Utility
        trashy # Alternative to rm and trash-cli
        macchanger # CLI Mac Changer
        zip # Compressor/archiver for creating and modifying zipfiles
        unzip # Extraction utility for archives compressed in .zip format
        gnutar # GNU implementation of the `tar' archiver
        yt-dlp
        # Goofy Software
        # cbonsai
        # nerdfetch
        asciiquarium
        sl
      ];
    };
}
