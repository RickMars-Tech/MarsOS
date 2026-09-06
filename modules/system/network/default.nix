{
  flake.modules.nixos.network =
    {
      self,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      imports = with self.modules.nixos; [
        bluetooth
        firewall
        wifi
      ];

      environment.systemPackages = with pkgs; [ proton-vpn ];

      services = {
        resolved = {
          enable = true;

          settings.Resolve = {
            Domains = [ "~." ];

            DNSOverTLS = true;

            fallbackDns = [
              #= Quad9 (Alternativa segura y privada)
              "9.9.9.9"
              "2620:fe::fe"
              #= Google (como último recurso)
              "8.8.8.8"
              "2001:4860:4860::8888"
            ];
          };
        };

        # Segurity
        openssh.enable = mkDefault false;
        fail2ban.enable = mkDefault false;
        samba.enable = false;
      };

      networking.nameservers = [
        "179.9.93.198#dnsforge.de"
        "179.9.1.117#dnsforge.de"

        # IPv6
        "2a01:4f8:151:34aa::198#dnsforge.de"
        "2a01:4f8:141:316d::117#dnsforge.de"
      ];
    };
}
