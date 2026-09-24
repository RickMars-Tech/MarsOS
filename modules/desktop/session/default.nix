{ self, ... }:
{
  flake.modules.nixos.session = {
    imports = with self.modules.nixos; [
      # niri-noctalia # Niri+Noctalia
      # cosmic_epoch
      fonts
    ];

  };
}
