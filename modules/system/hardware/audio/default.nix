{
  imports = [
    ./packages.nix
    ./pipewire.nix
    ./wireplumber.nix
  ];
  services.playerctld.enable = true;
}
