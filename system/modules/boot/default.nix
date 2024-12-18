{ ... }: {

    imports = [
        ./boot.nix
        ./kernel/default.nix
        ./security.nix
        ./systemd.nix
        ./udev.nix
    ];

}
