{
  flake.modules.nixos.sudo-rs = {
    security.sudo-rs = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults insults
      '';
    };
  };
}
