{
  flake.modules.nixos.network =
    {
      config,
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

      environment.systemPackages = with pkgs; [
        proton-vpn
        inetutils
      ];

      services = {
        resolved = {
          # Nota: con COSMIC habilitado, systemd-resolved queda apagado (COSMIC
          # gestiona la red/DNS) y todo el bloque settings.Resolve de abajo NO
          # se aplica. Se conserva para el caso de desactivar COSMIC.
          enable = !config.services.desktopManager.cosmic.enable;

          settings.Resolve = {
            Domains = [ "~." ];

            # DNSOverTLS para mayor privacidad y seguridad
            # Las claves DEBEN llevar mayúscula inicial: systemd-resolved ignora
            # silenciosamente las minúsculas (log: "Unknown key ... ignoring")
            DNSOverTLS = "opportunistic";

            FallbackDNS = [
              #= Cloudflare (Block Malware)
              "1.1.1.2"
              "2606:4700:4700::1112"
              "1.0.0.2"
              "2606:4700:4700::1002"
              #= Quad9 (Alternativa segura y privada)
              "9.9.9.9"
              "2620:fe::fe"
              #= Google (como último recurso)
              "8.8.8.8"
              "2001:4860:4860::8888"
            ];

            DNSSEC = "allow-downgrade";

            MulticastDNS = true;
            LLMNR = true;
            ReadEtcHosts = true;
            ResolveUnicastSingleLabel = false;
            Cache = true;
            CacheFromLocalhost = false;
            DNSStubListener = true;
          };
        };

        #== Segurity
        openssh.enable = false; # Servidor SSH desactivado (no se usa en esta laptop)
        fail2ban.enable = mkDefault false;
        samba.enable = false;
      };
    };
}
