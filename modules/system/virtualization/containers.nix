{
  pkgs,
  username,
  ...
}: {
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
    docker = {
      enable = true;
      enableOnBoot = false;
      extraPackages = with pkgs; [docker-compose];
    };
  };

  users.users.${username}.extraGroups = ["podman" "docker"];
}
