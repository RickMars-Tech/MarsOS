{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  gaming = config.mars.gaming;
in {
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

    #= Gaming-Related PAM Limits
    pam = {
      loginLimits = mkIf gaming.enable [
        {
          domain = "@games";
          type = "soft";
          item = "rtprio";
          value = "99";
        }
        {
          domain = "@games";
          type = "hard";
          item = "rtprio";
          value = "99";
        }
        {
          domain = "@games";
          type = "soft";
          item = "nice";
          value = "-20";
        }
        {
          domain = "@games";
          type = "hard";
          item = "nice";
          value = "-20";
        }
      ];
      services.swaylock.text = ''
        auth include login
      '';
    };
  };
}
