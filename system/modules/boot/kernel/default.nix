{ pkgs, ...}: {

    imports = [ ./common.nix ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

}
