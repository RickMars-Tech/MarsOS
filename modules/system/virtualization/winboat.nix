{
  flake.modules.nixos.winboat =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        winboat
      ];
    };
}
