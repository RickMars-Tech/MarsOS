{
  pkgs,
  fullname,
  username,
  ...
}: {
  #= If you going to define a new user account, don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.fish;
    users.${username} = {
      isNormalUser = true;
      createHome = true;
      description = "${fullname}";
      initialPassword = "010304yo6661";
      group = "wheel";
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
      useDefaultShell = true;
    };
  };
}
