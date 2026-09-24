{
  flake.modules.nixos.obs =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
          obs-composite-blur
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
          obs-vaapi
        ];
      };

      environment.systemPackages = with pkgs; [ kdePackages.kdenlive ];
    };
}
