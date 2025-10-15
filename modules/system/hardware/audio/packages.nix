{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alsa-utils
    pwvucontrol
    easyeffects
  ];
}
