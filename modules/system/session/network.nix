{
  pkgs,
  lib,
  ...
}: {
  #= NetworkD(Iwd).
  systemd.network = {
    enable = true;
    networks = {
      "80-wired" = {
        matchConfig = {Name = "enp*s*";};
        DHCP = "yes";
      };
      "80-wireless" = {
        matchConfig = {Name = "wlan*";};
        DHCP = "yes";
      };
    };
    wait-online.enable = false;
  };

  #= Host & Firewall
  networking = {
    hostName = "nixos"; # Define your hostname.
    useDHCP = lib.mkForce false; # Already defined on systemd.network.networks.<name>.DHCP
    enableIPv6 = true;
    wireless.iwd = {
      enable = true;
      settings = {
        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
        Settings = {
          AutoConnect = true;
          EnableNetworkConfiguration = true; # DHCP vía iwd
          PowerSave = true; # Ahorro de energía
        };
      };
    };
    firewall = {
      enable = true;
      allowPing = false;
      #checkReversePath = "loose"; # libvirt DHCP compatibility
      #pingLimit = "--limit 1/minute --limit-burst 5";
      allowedTCPPorts = [
        80 # http
        443 # https
        53 # DNS
        123 # NTP
        # TLS/SSl
        465
        587
        993
        995
      ];
    };
    dhcpcd = {
      enable = false;
      #extraConfig = "nohook resolv.conf";
    };
    nameservers = [
      #Quad9
      "9.9.9.9"
      "2620:fe::fe"
      #Mullvad
      "194.242.2.4"
      "2a07:e340::4"
    ];
  };
  environment.systemPackages = with pkgs; [iwgtk]; # GTK Front-end for IWD
  services.resolved.enable = true;

  #= Bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  services = {
    #= Pairing Bluetooth devices
    blueman.enable = true;

    timesyncd.enable = false;

    #= Fail2Ban
    fail2ban = {
      enable = false; # I dont use SSH, so i can disable this to reduce services in background
      ignoreIP = [
        "9.9.9.11"
        "149.112.112.11"
        "2620:fe::11"
        "2620:fe::fe:11"
      ];
      maxretry = 5;
      bantime = "12h";
    };

    # Desactivar servicios innecesarios que abren puertos
    openssh.enable = false; # Solo habilita si usas SSH como servidor
    samba.enable = false; # Desactiva SMB (puerto 445)
    miniupnpd.upnp = false;
  };
}
