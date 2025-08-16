# https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/bin/pci-latency
{pkgs}:
pkgs.writeShellScriptBin "pci-latency" ''
  #!/usr/bin/env sh
  # Check if the script is run with root privileges
  if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run with root privileges." >&2
    exit 1
  fi

  # Reset the latency timer for all PCI devices
  ${pkgs.pciutils}/bin/setpci -v -s '*:*' latency_timer=20
  ${pkgs.pciutils}/bin/setpci -v -s '0:0' latency_timer=0

  # Set latency timer for all sound cards
  ${pkgs.pciutils}/bin/setpci -v -d "*:*:04xx" latency_timer=80
''
