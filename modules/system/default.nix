{
  flake.modules.nixos.system =
    { self, ... }:
    {
      imports = with self.modules.nixos; [
        core
        hardwareCore
        network
        nix
      ];
      # Force to NOT use ARM/Windows/etc binaries
      boot.binfmt.emulatedSystems = [ ];
    };
}
