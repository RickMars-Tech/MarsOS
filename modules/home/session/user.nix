{
  fullname,
  username,
  config,
  ...
}: {
  #= If you going to define a new user account, don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell =
      if config.mars.shell.fish
      then config.programs.fish.package
      else config.programs.bash.package;

    users.${username} = {
      isNormalUser = true;
      createHome = true;
      description = "${fullname}";
      group = "wheel";
      extraGroups = [
        "video" # Display/GPU access
        "audio" # Audio access
        "render" # GPU rendering
        "input" # Input devices
        "dialout" # Serial devices

        # Development (as needed)
        "git"

        # Gaming
        "games"
        "gamemode"

        # Containers/Virtualization (condicional)
        "libvirt"
        "kvm"
        "qemu"

        # Network management
        "networkmanager"
      ];
      useDefaultShell = true;
    };
  };

  services.accounts-daemon.enable = true;
}
