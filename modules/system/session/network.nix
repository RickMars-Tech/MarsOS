{
  config,
  pkgs,
  lib,
  ...
}: {
  #= Host & Firewall
  networking = {
    # hostName = "nixos"; # Define your hostname.
    useDHCP = lib.mkDefault true;
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
    powerOnBoot = false; # powers up the default Bluetooth controller on boot
    package = pkgs.bluez;
  };

  services = {
    #= Pairing Bluetooth devices
    blueman.enable = config.hardware.bluetooth.enable;

    timesyncd.enable = false;
    # Desactivar servicios innecesarios que abren puertos
    openssh.enable = false; # Solo habilita si usas SSH como servidor
    samba.enable = false; # Desactiva SMB (puerto 445)
    miniupnpd.upnp = false;
  };
}
