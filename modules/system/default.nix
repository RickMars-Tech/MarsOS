{
  flake.modules.nixos.system =
    { self, ... }:
    {
      imports = with self.modules.nixos; [
        core
        hardware
        network
        nix
      ];
    };
}
