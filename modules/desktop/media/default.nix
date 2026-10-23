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
        # Music Players
        kopuz
        cliamp

        # Otros
        blender
        imagemagick
        kdePackages.kdenlive
      ];
    };
}
