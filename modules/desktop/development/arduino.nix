{
  flake.modules.nixos.arduino =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        arduino-core
        arduino-cli
        arduino-ide
      ];
    };
}
