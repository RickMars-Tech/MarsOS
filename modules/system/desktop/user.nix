{
  pkgs,
  name,
  username,
  ...
}: {
  #= If you going to define a new user account, don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    description = "${name}";
    group = "wheel"; # enable 'sudo'
    extraGroups = [
      "video"
      "audio"
      "render"
      "git"
      "games"
      "gamemode"
      "storage"
      "pipewire"
      "disk"
      "libvirt"
      "flatpak"
      "networkmanager"
      "kvm"
      "qemu"
      "input"
      "dialout"
    ];
    shell = pkgs.fish;
  };
}
