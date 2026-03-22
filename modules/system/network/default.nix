{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./bluetooth.nix
    ./firewall.nix
    ./wifi.nix
  ];

  # DNS optimizado
  services = {
    timesyncd = {
      enable = true;
      extraConfig = "RootDistanceMaxSec=5";
    };
    resolved = {
      enable = true;

      settings.Resolve = {
        Domains = ["~."];

        # DNSOverTLS para mayor privacidad y seguridad
        dnsovertls = "opportunistic";

        fallbackDns = [
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

        dnssec = "allow-downgrade";

        MulticastDNS = true;
        LLMNR = true;
        ReadEtcHosts = true;
        ResolveUnicastSingleLabel = false;
        Cache = true;
        CacheFromLocalhost = false;
        DNSStubListener = true;
        DNSStubListenerExtra = "127.0.0.53";
      };
    };

    #== Segurity
    openssh.enable = mkDefault false;
    fail2ban.enable = mkDefault false;
    samba.enable = false;
  };
}
