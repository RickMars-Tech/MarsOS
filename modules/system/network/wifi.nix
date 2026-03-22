{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  networking = {
    useDHCP = mkDefault true;
    enableIPv6 = true;

    networkmanager = {
      enable = true;
      wifi = {
        backend = mkDefault "wpa_supplicant";
        macAddress = mkDefault "preserve";
        powersave = mkDefault false;
        scanRandMacAddress = false;
      };
      dns = "systemd-resolved"; #"default";
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
  };
}
