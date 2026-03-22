{
  networking = {
    nftables.enable = false;
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
  };
}
