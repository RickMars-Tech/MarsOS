{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    aubio
    alsa-lib
    alsa-plugins
    alsa-utils
    pwvucontrol
  ];
}
