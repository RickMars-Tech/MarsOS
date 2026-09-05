{
  flake.modules.nixos.firefox =
    {
      config,
      pkgs,
      self,
      lib,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        firefoxExtensions
        firefoxPolices
        firefoxSearch
        firefoxSettings
      ];
      programs.firefox = {
        enable = true;
        languagePacks = [
          "es-MX"
          "en-US"
        ];
        # package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { };
      };

      environment.sessionVariables = {
        BROWSER = "${lib.getExe config.programs.firefox.package}";
        MOZ_USE_XINPUT2 = "1"; # Touchpad Gestures and Smooth Scrolling
        MOZ_ENABLE_WAYLAND = "1"; # Force Wayland
      };
    };
}
