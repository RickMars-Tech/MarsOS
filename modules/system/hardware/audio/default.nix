{ self, ... }:
{
  flake.modules.nixos.audio =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        pipewire
        wireplumber
      ];
      environment.systemPackages = with pkgs; [
        alsa-utils
        pwvucontrol
        easyeffects
      ];
      services.speechd.enable = lib.mkForce false;
    };
}
