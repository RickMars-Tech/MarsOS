{
  flake.modules.nixos.gamingLaunchers =
    { self, pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        prism
        steam
      ];
      environment.systemPackages = with pkgs; [
        # Emulation
        ryubing

        heroic # GOG, Epic etc...

        chess-tui
        gnuchess
        stockfish

        bottles # Not a launcher, but very usefull

        # Own Packaged
        hytale-launcher
        opengoal
      ];
    };
}
