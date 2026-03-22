{pkgs, ...}: {
  imports = [
    ./module.nix
    ./config
  ];
  programs.niri = {
    enable = true;
    useNautilus = true;
    withXDG = true;
  };

  environment.systemPackages = with pkgs; [
    # Wayland core utilities
    wl-mirror
    wl-clipboard-rs
    cliphist

    # Applications
    papers
    file-roller
    swayimg
  ];
}
