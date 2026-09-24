{ self, ... }: {
  flake.modules.nixos.cosmic_epoch =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib) optional mkForce;
    in
    {
      imports = [ self.modules.nixos.cosmic_greeter ];

      services = {
        desktopManager.cosmic = {
          enable = true;
          xwayland.enable = true;
          showExcludedPkgsWarning = false;
        };

        # Use oo7 instead of Gnome K-ring
        oo7.enable = true;
        gnome.gnome-keyring.enable = mkForce false;
      };

      environment = {
        # Extra Apps for Cosmic
        systemPackages = with pkgs; [
          cosmic-viewer
          cosmic-ext-calculator
          cosmic-ext-tweaks
          cutecosmic
          wl-clipboard-rs
        ];

        # Clipboard Fix
        sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

        # Excluded Packages
        cosmic.excludePackages =
          with pkgs;
          [
            cosmic-edit
            cosmic-store
            cosmic-player
            cosmic-greeter
          ]
          ++ optional (!config.services.displayManager.cosmic-greeter.enable) [
            cosmic-greeter
          ];

      };
    };
}
