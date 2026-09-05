{
  flake.modules.nixos.podman =
    {
      pkgs,
      username,
      ...
    }:
    {
      virtualisation = {
        podman = {
          enable = false;
          dockerCompat = false;
          autoPrune.enable = true;
          defaultNetwork.settings.dns_enabled = true;
          extraPackages = with pkgs; [
            podman-compose
          ];
        };
      };

      users.users.${username}.extraGroups = [ "podman" ];
    };
}
