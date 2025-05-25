_: {
  security = {
    auditd.enable = false;

    #==< Polkit >==#
    polkit = {
      enable = true;
    };
    #= Better PolkitAgent Writed in Rust
    soteria = {
      enable = true;
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

    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };
}
