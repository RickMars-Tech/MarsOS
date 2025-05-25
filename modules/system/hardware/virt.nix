_: {
  #= General
  virtualisation = {
    libvirtd.enable = false;
    waydroid.enable = false;
  };
  #environment.systemPackages = with pkgs; [ waydroid ];

  #=> Virt-Manager
  programs.virt-manager.enable = false;
}
