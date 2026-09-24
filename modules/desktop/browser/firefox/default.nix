{
  flake.modules.nixos.firefox =
    {
      # config,
      self,
      # lib,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        firefoxExtensions
        firefoxPolicies
        firefoxSearch
        firefoxSettings
      ];
      programs.firefox = {
        enable = true;
        languagePacks = [
          "es-MX"
          "en-US"
        ];
      };

      environment.sessionVariables = {
        BROWSER = "firefox";
        MOZ_USE_XINPUT2 = "1"; # Touchpad Gestures and Smooth Scrolling
        MOZ_ENABLE_WAYLAND = "1"; # Force Wayland
      };
    };
}
