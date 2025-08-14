{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  #= Host & Firewall
  networking = {
    # hostName = "nixos"; # Define your hostname.
    useDHCP = mkDefault true;
    enableIPv6 = true;
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = false;
      };
    };
    firewall = {
      enable = true;
      allowPing = false;
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
  };
  environment.systemPackages = with pkgs; [networkmanagerapplet]; # GTK Front-end for IWD
  services.resolved.enable = true;

  #= Bluetooth
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    package = pkgs.bluez;
  };

  services = {
    #= Pairing Bluetooth devices
    blueman.enable = config.hardware.bluetooth.enable;

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
