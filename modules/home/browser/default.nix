{pkgs, ...}: {
  imports = [
    ./extensions.nix
    ./polices.nix
    ./searchEngine.nix
    ./settings.nix
  ];

  programs.firefox = {
    enable = true;
    languagePacks = ["es-MX" "en-US"];
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1"; # Touchpad Gestures and Smooth Scrolling
    MOZ_ENABLE_WAYLAND = "1"; # Force Wayland
  };
}
