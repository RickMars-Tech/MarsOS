{
  flake.modules.nixos.asus =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkForce;
    in
    {
      boot = {
        kernelParams = [
          "acpi_backlight="
          "acpi_osi=!"
          "acpi_osi=\"Windows 2020\""
        ];
      };
      services = {
        asusd = {
          enable = true;
          package = pkgs.asusctl;
        };

        # make problems with Nouveau and its not needed for Nvidia Privative Driver
        # and for some reason, asusd enable it
        supergfxd.enable = mkForce false;
      };
    };
}
