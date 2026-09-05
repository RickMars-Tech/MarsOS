{
  flake.modules.nixos.firewall = {
    networking = {
      nftables.enable = true;

      firewall = {
        enable = true;
        # backend = "nftables"; # redundante con nftables.enable

        allowPing = true; # útil para diagnosticar red local

        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];

        # Rechaza en vez de silenciar — más rápido para el cliente
        rejectPackets = true;

        # Reglas extra de nftables aplicadas antes del firewall de NixOS
        extraInputRules = ''
          # Descartar paquetes con estado inválido (anti-spoofing básico)
          ct state invalid drop

          # Rate limiting para nuevas conexiones TCP (anti-scan)
          tcp flags syn ct state new \
            limit rate over 10/second burst 20 packets drop
        '';

        # Protección en la cadena de reenvío (importante si usas VMs/containers)
        extraForwardRules = ''
          ct state invalid drop
        '';
      };
    };
  };
}
