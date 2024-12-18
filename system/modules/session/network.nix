{ pkgs, lib, ... }: {

#= NetworkD(Iwd).
    systemd.network = {
        enable = true;
        networks = {
            "90-interfaces" = {
                matchConfig = { Name = "*"; };
                DHCP = "yes";
            };
            "80-wired" = {
                matchConfig = { Name = "enp*s*"; };
                DHCP = "yes";
            };
        };
        wait-online.enable = false;
    };

#= Host & Firewall
    networking = {
        hostName = "nixos"; # Define your hostname.
        useDHCP = lib.mkForce false;
        enableIPv6 = false;
        wireless.iwd = {
            enable = true;
            settings = {
                Settings = {
                    AutoConnect = true;
                };
            };
        };
        firewall = {
            enable = true;
            checkReversePath = "loose"; # libvirt DHCP compatibility
            pingLimit = "--limit 1/minute --limit-burst 5";
            allowedTCPPorts = [
                22
                53
                80
                443
                631
                3478
                3479
                8080
            ];
            allowedUDPPortRanges = [
                { from = 4000; to = 4007; }
                { from = 8000; to = 8010; }
            ];
        };
        dhcpcd = {
            enable = true;
            extraConfig = "nohook resolv.conf";
        };
        nameservers = [
            #Quad9
            "9.9.9.9"
            "2620:fe::fe"
            #Mullvad
            # "100.64.0.63"
            "194.242.2.4"
            "2a07:e340::4"
            # local
            # "127.0.0.1"
            # "::1"
        ];
    };
    environment.systemPackages = with pkgs; [ iwgtk ]; # GTK Front-end for IWD
    services.resolved.enable = false;

#= Bluetooth
    hardware.bluetooth = {
        enable = true; # enables support for Bluetooth
        powerOnBoot = false; # powers up the default Bluetooth controller on boot
    };
    #= Pairing Bluetooth devices
    services.blueman.enable = true;

#= Fail2Ban
    services.fail2ban = {
        enable = true;
        ignoreIP = [
            "9.9.9.11"
            "149.112.112.11"
            "2620:fe::11"
            "2620:fe::fe:11"
        ];
        maxretry = 5;
        bantime = "12h";
    };
}
