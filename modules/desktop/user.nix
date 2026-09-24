{
  flake.modules.nixos.user =
    {
      fullname,
      username,
      inputs,
      ...
    }:
    {
      imports = [ inputs.hjem.nixosModules.default ];
      #= If you going to define a new user account, don't forget to set a password with ‘passwd’.
      users = {
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

      # Hjem
      hjem.users.${username} = {
        # enable = true; # This is not necessary, since enable is 'true' by default
        user = "${username}"; # this is the name of the user
        directory = "/home/${username}"; # where the user's $HOME resides
        clobberFiles = true;

        # Assets & Wallpapers
        files = {
          "wallpapers" = {
            type = "symlink"; # "copy";
            target = "wallpapers";
            source = ../../assets/wallpapers;
          };
          ".face.jpg" = {
            type = "symlink";
            source = ../../assets/profile.jpg;
          };
        };
      };
    };
}
