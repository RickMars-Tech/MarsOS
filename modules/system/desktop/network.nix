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
      };
      dns = "systemd-resolved";
    };
    firewall = {
      enable = true;
      allowPing = false;
    };
    nameservers = ["8.8.8.8" "8.8.4.4"];
  };
  environment.systemPackages = with pkgs; mkIf (config.hardware.bluetooth.enable) [networkmanagerapplet bluetui bluez];

  #= Bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = false; # powers up the default Bluetooth controller on boot
    package = pkgs.bluez;
  };

  services = {
    #= Pairing Bluetooth devices
    blueman.enable = config.hardware.bluetooth.enable;

    # DNS optimizado para uso personal
    resolved = {
      enable = true;
      domains = ["~."];
      fallbackDns = [
        #= Claudflare(Block Malware)
        "1.1.1.2"
        "2606:4700:4700::1112 "
        "1.0.0.2"
        "2606:4700:4700::1002"
        #= Google
        "8.8.8.8"
        "2001:4860:4860::8888"
        "8.8.4.4"
        "2001:4860:4860::8844"
      ];
      dnssec = "allow-downgrade";
      extraConfig = ''
        MulticastDNS=yes
        LLMNR=yes
        ReadEtcHosts=yes
        ResolveUnicastSingleLabel=no
        Cache=yes
      '';
    };

    #== Disable some Things for better Security
    timesyncd.enable = false;
    # Desactivar servicios innecesarios que abren puertos
    openssh = {
      enable = mkDefault false; # Disabled by default, enable per host
      settings = {
        PasswordAuthentication = mkDefault false;
        PermitRootLogin = mkDefault "no";
        X11Forwarding = mkDefault false;
      };
    };
    # Fail2ban for SSH protection when enabled (requires firewall)
    fail2ban = {
      enable = config.services.openssh.enable && config.networking.firewall.enable;
      maxretry = 3;
      bantime = "10m";
    };
    samba.enable = false; # Desactiva SMB (puerto 445)
    miniupnpd.upnp = false;
  };
}
