_: {
  security = {
    #==> Polkit <==#
    polkit = {
      enable = true;
    };

    # PolkitAgent Writed in Rust
    soteria = {
      enable = true;
    };

    #==> MemorySafe for Sudo <==#
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
  };
}
