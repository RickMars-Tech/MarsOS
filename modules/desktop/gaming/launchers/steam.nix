{
  flake.modules.nixos.steam =
    {
      username,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          extest.enable = false;
          protontricks.enable = mkDefault false;
          package = pkgs.steam.override {
            # https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-2425213386
            extraProfile = ''
              unset TZ
            '';
            extraEnv = {
              # https://wiki.cachyos.org/configuration/gaming/#fix-stuttering-caused-by-the-steam-game-recorder-feature
              LD_PRELOAD = "";

              # Proton optimizations
              PROTON_USE_WINED3D = "0";
              PROTON_NO_ESYNC = "0";
              PROTON_NO_FSYNC = "0";

              # Gaming-specific OpenGL optimizations
              __GL_THREADED_OPTIMIZATIONS = "1";
              __GL_SHADER_DISK_CACHE = "1";
              __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
            };
            privateTmp = false; # https://github.com/NixOS/nixpkgs/issues/381923
          };
          extraCompatPackages = with pkgs; [
            (proton-ge-bin.overrideAttrs (_: {
              steamDisplayName = "Proton GE";
            }))
            # proton-em
            proton-cachyos-bin
          ];
        };
      };

      hardware.steam-hardware.enable = true;

      environment = {
        sessionVariables = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

          # DXVK optimizations
          DXVK_LOG_LEVEL = "none";
          DXVK_CONFIG_FILE = "/etc/dxvk.conf";

        };
        systemPackages = with pkgs; [
          steam-run
          protontricks
          protonplus
        ];
      };

      # Steam Download Fixes
      hjem.users.${username}.xdg.data.files."Steam/steam_dev.cfg" = {
        text = ''
          @eHTTP2PlatformLinux 0
          @nClientDownloadEnableHTTP2PlatformLinux 0
          @fDownloadRateImprovementToAddAnotherConnection 1.0
          @unShaderBackgroundProcessingThreads 6
        '';
      };
    };
}
