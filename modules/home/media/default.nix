{ self, ... }:
{
  flake.modules.nixos.media =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        mpv
        obs
      ];
      environment.systemPackages = with pkgs; [
        amberol # Music Player
        oculante # Image Viewer
        pixieditor
        blender
      ];
    };
}
