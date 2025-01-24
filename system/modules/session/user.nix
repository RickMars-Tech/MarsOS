{ pkgs, ... }: {

#= Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.rick = {
        isNormalUser = true;
        createHome = true;
        description = "Rick";
        group = "wheel"; # enable 'sudo'
        extraGroups = [
            "video"
            "audio"
            "render"
            "git"
            "games" # Access to some game software. /var/games.
            "gamemode" # Required for 'renicing' via gamemode.
            "storage" # Used to gain access to removable drives such as USB hard drives.
            "pipewire"
            "disk"
            "libvirt"
            "flatpak"
            "networkmanager"
            "kvm"
            "qemu"
            "input"
        ];
        shell = pkgs.nushell;
    };

}
