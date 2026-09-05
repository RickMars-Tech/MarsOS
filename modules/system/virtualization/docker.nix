{
  flake.modules.nixos.docker =
    {
      pkgs,
      username,
      ...
    }:
    {
      virtualisation = {
        docker = {
          enable = true;
          enableOnBoot = false;
          extraPackages = with pkgs; [ docker-compose ];
        };
      };

      users.users.${username}.extraGroups = [ "docker" ];
    };
}
