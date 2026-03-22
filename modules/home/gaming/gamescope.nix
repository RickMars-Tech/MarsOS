{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  gaming = config.mars.gaming;
  gamescope = config.mars.gaming.gamescope;
in {
  options.mars.gaming.gamescope = {
    enable = mkEnableOption "Enable Gamescope" // {default = false;};
  };
  config = {
    programs.gamescope = {
      enable = mkIf (gaming.enable && gamescope.enable) true;
      capSysNice = false;
      args = [
        "--force-grab-cursor"
        "--adaptive-sync" # VRR (uncomment if your display supports it)

        # Examples:
        # "-f"
        # "-e"
        # "--expose-wayland" # Support Wayland Clients
        # "--rt" # Use Realtime Scheduling
        # "--mangoapp" # MangoHUD integration
        # "--prefer-vk-device" # Prefer Vulkan rendering
      ];
      package = pkgs.gamescope.overrideAttrs (
        prev: {
          # https://github.com/ValveSoftware/gamescope/issues/1622
          NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
          patches =
            prev.patches
            ++ [
              # Fix Gamescope not closing https://github.com/ValveSoftware/gamescope/pull/1908
              (pkgs.fetchpatch {
                url = "https://github.com/ValveSoftware/gamescope/commit/fa900b0694ffc8b835b91ef47a96ed90ac94823b.patch?full_index=1";
                hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
              })
            ];
        }
      );
    };
  };
}
