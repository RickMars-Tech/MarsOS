{
  flake.modules.nixos.virtualization =
    {
      pkgs,
      username,
      lib,
      ...
    }:
    let
      inherit (lib) mkForce;
    in
    {
      virtualisation = {
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          package = pkgs.libvirt;
          qemu = {
            package = pkgs.qemu;
            swtpm = {
              enable = true;
            };
          };
        };
      };
      users.users.${username}.extraGroups = [ "libvirtd" ];

      # Both units were WantedBy=multi-user.target, which makes multi-user.target wait
      # for them (targets imply After= for wanted units). libvirtd took 2.24s to become
      # ready and that was gating multi-user.target -> graphical.target -> greetd,
      # i.e. ~2.2s of black screen before the greeter could even start.
      # libvirtd.socket is still WantedBy=sockets.target and activates libvirtd.service
      # on the first connection, so virsh / virt-manager / winboat start it on demand.
      systemd.services = {
        libvirtd.wantedBy = mkForce [ ];
        libvirt-guests.wantedBy = mkForce [ ];
      };

      services.spice-vdagentd.enable = false; # Solo necesario dentro de VMs SPICE

      programs.virt-manager.enable = true;

      networking.firewall.trustedInterfaces = [ "virbr0" ];

      environment.systemPackages = with pkgs; [
        freerdp
        dnsmasq
      ];
    };
}
