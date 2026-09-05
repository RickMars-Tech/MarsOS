{
  flake.modules.nixos.doas =
    { pkgs, ... }:
    {
      security.doas = {
        enable = true;
        wheelNeedsPassword = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            keepEnv = true;
            persist = true; # Opcional: mantiene la sesión autenticada por un tiempo
          }
        ];

        environment.systemPackages = [
          pkgs.doas-sudo-shim
        ];
      };
    };
}
