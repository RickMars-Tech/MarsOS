{
  flake.modules.nixos.gamescope = {
    programs.gamescope = {
      enable = true;
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
    };
  };
}
