{ ... }: {

#= General
     virtualisation = {
         libvirtd.enable = false;
         waydroid.enable = false;
    };
    #environment.systemPackages = with pkgs; [ waydroid ];

#=> Virt-Manager
    programs.virt-manager.enable = false;

#=> Enable AMD SEV (For Memory Security).
    hardware.cpu.amd.sev.enable = true;
    hardware.cpu.amd.sevGuest.enable = true;
}
