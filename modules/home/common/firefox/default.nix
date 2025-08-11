{pkgs, ...}: {
  imports = [
    ./polices.nix
    ./profile.nix
    ./settings.nix
  ];
  programs.firefox = {
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
    enable = true;
  };
}
