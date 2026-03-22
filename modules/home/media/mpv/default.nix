{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  configFile = "mpv/mpv.conf";
  inputFile = "mpv/input.conf";
in {
  config = mkIf config.mars.multimediaSoftware {
    environment.systemPackages = with pkgs; [
      mpv
      mpvScripts.mpris
      mpvScripts.uosc
      mpvScripts.thumbfast
      mpvScripts.sponsorblock
    ];

    xdg.configFile."${configFile}".text =
      lib.generators.toKeyValue {
        mkKeyValue = k: v: "${lib.escapeShellArg k}=${lib.escapeShellArg v}";
        listsAsDuplicateKeys = true;
      } {
        profile = "gpu-hq";
        osc = "no";
        "osd-bar" = "no";
        volume = "100";
        "volume-max" = "200";
      };

    xdg.configFile."${inputFile}".text =
      lib.generators.toKeyValue {
        mkKeyValue = k: v: "${lib.escapeShellArg k}=${lib.escapeShellArg v}";
        listsAsDuplicateKeys = true;
      } {
        "ctrl+a" = "script-message osc-visibility cycle";
        "UP" = "add volume +5";
        "DOWN" = "add volume -5";
        "CTRL+1" = ''no-osd change-list glsl-shaders set "~~/shaders/FSR.glsl"; show-text "FSR"'';
        "CTRL+2" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_AutoDownscalePre_x2.glsl"; show-text "Anime4K_ADPx2"'';
        "CTRL+3" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_AutoDownscalePre_x4.glsl"; show-text "Anime4K_ADPx4"'';
        "CTRL+4" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl"; show-text "Anime4K_ClamHighlights"'';
        "CTRL+5" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Restore_CNN_M.glsl"; show-text "Anime4K_RestoreCNN_M"'';
        "CTRL+6" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Restore_CNN_VL.glsl"; show-text "Anime4K_RestoreCNN_VL"'';
        "CTRL+7" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K_UpscaleCNN_x2_M"'';
        "CTRL+8" = ''no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl"; show-text "Anime4K_UpscaleCNN_x2_VL"'';
        "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
      };

    xdg.configFile."mpv/shaders" = {
      source = ./shaders;
      recursive = true;
    };
  };
}
