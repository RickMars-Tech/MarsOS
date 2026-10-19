{
  flake.modules.nixos.gameDev = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      godot
      libresprite
      pixieditor
    ];
  };
}
