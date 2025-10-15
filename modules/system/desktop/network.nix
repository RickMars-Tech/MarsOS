{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  #= Host & Firewall
  networking = {
    useDHCP = mkDefault true;
    enableIPv6 = true;

    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = false;
        scanRandMacAddress = true;
      };
      dns = "systemd-resolved";
      dispatcherScripts = [
        {
          source = pkgs.writeText "upHook" ''
            if [ "$2" = "up" ]; then
              # Optimización de MTU para WiFi
              ${pkgs.iproute2}/bin/ip link set "$1" mtu 1500
            fi
          '';
        }
      ];
    };

    firewall = {
      enable = true;
      allowPing = false;
      logRefusedConnections = mkDefault false;
      checkReversePath = "loose";
    };
  };

  environment.systemPackages = with pkgs;
    mkIf (config.hardware.bluetooth.enable) [
      networkmanagerapplet
      bluetui
      bluez
      # Herramientas útiles para diagnóstico de red
      iw
      wirelesstools
      wavemon # Monitor de señal WiFi en tiempo real
    ];

  #= Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    package = pkgs.bluez;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true; # Mejoras de latencia
        KernelExperimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = false;
      };
    };
  };

  services = {
    #= Pairing Bluetooth devices
    blueman.enable = config.hardware.bluetooth.enable;

    # DNS optimizado
    resolved = {
      enable = true;
      domains = ["~."];

      # DNSOverTLS para mayor privacidad y seguridad
      dnsovertls = "opportunistic";

      fallbackDns = [
        #= Cloudflare (Block Malware) - CORREGIDO: tenías un espacio extra
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

      extraConfig = ''
        MulticastDNS=yes
        LLMNR=yes
        ReadEtcHosts=yes
        ResolveUnicastSingleLabel=no
        Cache=yes
        CacheFromLocalhost=no
        DNSStubListener=yes
        DNSStubListenerExtra=127.0.0.53
      '';
    };

    #= IWD configuration para mejor rendimiento WiFi
    # Crear archivo de configuración de iwd
  };

  # Configuración de iwd para máximo rendimiento
  environment.etc."iwd/main.conf".text = lib.mkForce ''
    [General]
    EnableNetworkConfiguration=false
    UseDefaultInterface=true
    AddressRandomization=network
    AddressRandomizationRange=full

    [Network]
    EnableIPv6=true
    RoutePriorityOffset=300

    [Scan]
    DisablePeriodicScan=false
    InitialPeriodicScanInterval=10
    MaximumPeriodicScanInterval=300

    [Settings]
    AutoConnect=true
  '';

  services = {
    #== Seguridad
    timesyncd.enable = false;
    chrony.enable = true;

    openssh = {
      enable = mkDefault false;
      settings = {
        PasswordAuthentication = mkDefault false;
        PermitRootLogin = mkDefault "no";
        X11Forwarding = mkDefault false;
        # Optimizaciones adicionales
        KbdInteractiveAuthentication = mkDefault false;
        UseDns = mkDefault false;
      };
    };

    fail2ban = {
      enable = config.services.openssh.enable && config.networking.firewall.enable;
      maxretry = 3;
      bantime = "10m";
      # Ignora LAN local
      ignoreIP = [
        "127.0.0.1/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
      ];
    };

    samba.enable = false;
  };
}
