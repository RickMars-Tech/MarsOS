{
  flake.modules.nixos.db =
    { pkgs, lib, ... }:
    {
      services.mysql = {
        enable = true;
        package = pkgs.mysql84;
      };

      # MySQL no arranca en el boot (consume ~479 MB de RAM y no se usa a
      # diario). El servicio queda instalado; se inicia a mano cuando se
      # necesite:  systemctl start mysql
      systemd.services.mysql.wantedBy = lib.mkForce [ ];

      environment.systemPackages = with pkgs; [
        mycli # autocompletion for MySQL
      ];
    };
}
