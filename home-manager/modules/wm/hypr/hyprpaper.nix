{pkgs, ...}: {
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = ["~/wal/arcane.png" "~/wal/spaceman.png" "~/wal/alone.png" "~/wal/nix-wallpaper-nineish-dark-gray.png"];
      wallpaper = [",~/wal/alone.png"];
    };
  };
}
