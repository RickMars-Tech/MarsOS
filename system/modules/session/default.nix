{ ... }: {

    imports = [
        ./gaming/default.nix
        ./wayland/default.nix
        ./dbus.nix
        ./env.nix
        ./flatpak.nix
        ./login-manager.nix
        ./network.nix
        ./packages.nix
        ./printing.nix
        ./user.nix
    ];
}
