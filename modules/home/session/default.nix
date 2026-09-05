{ self, ... }:
{
  flake.modules.nixos.session = {
    imports = with self.modules.nixos; [
      # nn # Niri+Noctalia
      cosmic_epoch
      fonts
      timezone
    ];

  };
}
