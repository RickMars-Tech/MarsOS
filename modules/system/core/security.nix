{pkgs, ...}: {
  security = {
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
      extraConfig = ''
        Defaults pwfeedback
        Defaults insults
      '';
    };

    # Audit framework
    audit.enable = true;
    auditd.enable = true;

    pam.services.swaylock.text = ''
      auth include login
    '';
  };
}
