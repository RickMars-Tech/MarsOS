{
  flake.modules.nixos.printers =
    { pkgs, ... }:
    {
      # Service
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          # hplip
        ];
      };

      # Packages
      environment.systemPackages = with pkgs; [
        # hplip
      ];
    };
}
