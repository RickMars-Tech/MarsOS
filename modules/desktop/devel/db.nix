{
  flake.modules.nixos.db =
    { pkgs, ... }:
    {
      services.mysql = {
        enable = true;
        package = pkgs.mysql84;
      };

      environment.systemPackages = with pkgs; [
        mycli # autocompletion for MySQL
      ];
    };
}
