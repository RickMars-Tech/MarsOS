{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  gaming = config.mars.gaming;
in {
  options.mars.security = {
    sudo-rs = mkEnableOption "Enable Sudo-Rs" // {default = false;};
    doas = mkEnableOption "Enable Doas" // {default = false;};
  };

  config = {
    assertions = [
      {
        assertion = !(config.mars.security.doas && config.mars.security.sudo-rs);
        message = "Only use one elevate program (Sudo-rs or Doas)";
      }
    ];

    security = {
      #==< Polkit >==#
      polkit.enable = true;

      #= Better PolkitAgent Written in Rust
      soteria = {
        enable = true;
        package = pkgs.soteria;
      };

      #==< Doas (Sudo-Like Program) >==#
      doas = mkIf config.mars.security.doas {
        enable = true;
        wheelNeedsPassword = true;
        extraRules = [
          {
            groups = ["wheel"];
            keepEnv = true;
            persist = true; # Opcional: mantiene la sesión autenticada por un tiempo
          }
        ];
      };

      #==< Memory-Safe Sudo >==#
      sudo-rs = mkIf config.mars.security.sudo-rs {
        enable = true;
        execWheelOnly = true;
        extraConfig = ''
          Defaults pwfeedback
          Defaults insults
        '';
      };

      # Deshabilita sudo tradicional cuando usas sudo-rs o doas
      sudo.enable = !config.mars.security.sudo-rs && !config.mars.security.doas;

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

    # systemPackages debe estar aquí, no dentro de security
    environment.systemPackages = mkIf config.mars.security.doas [
      pkgs.doas-sudo-shim
    ];
  };
}
