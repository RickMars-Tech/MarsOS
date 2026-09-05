{ self, ... }:
{
  flake.modules.nixos.terminal = {
    imports = with self.modules.nixos; [
      shell
      wezterm
      yazi
    ];
  };
}
