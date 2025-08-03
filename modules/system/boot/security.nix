{pkgs, ...}: {
  security = {
    # apparmor = {
    #   enable = true;
    #   killUnconfinedConfinables = true;
    # };

    auditd.enable = false;

    #==< Polkit >==#
    polkit.enable = true;
    #= Better PolkitAgent Writed in Rust
    soteria = {
      enable = true;
      package = pkgs.soteria;
    };

    #==< MemorySafe for Sudo >==#
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      /*
      extraConfig = ''
        Defaults pwfeedback
        Defaults insults
      '';
      */
    };

    # pam.services.swaylock.text = ''
    #   auth include login
    # '';
    lockKernelModules = false; # NixOS necesita cargar módulos dinámicamente
    # allowSimultaneousMultithreading = false; # Deshabilita SMT por seguridad
    forcePageTableIsolation = true; # Fuerza PTI
    virtualisation.flushL1DataCache = "always"; # Mitiga ataques de cache
  };
}
