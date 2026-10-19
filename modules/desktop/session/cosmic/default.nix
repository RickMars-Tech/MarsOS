{ self, ... }: {
  flake.modules.nixos.cosmic_epoch =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib) optionals;
    in
    {
      imports = with self.modules.nixos; [
        cosmic_greeter
        dbus
      ];

      services = {
        desktopManager.cosmic = {
          enable = true;
          xwayland.enable = true;
          showExcludedPkgsWarning = false;
        };
      };

      environment = {
        # Extra Apps for Cosmic
        systemPackages = with pkgs; [
          cosmic-ext-calculator
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
          ]
          ++ optionals (!config.services.displayManager.cosmic-greeter.enable) [
            config.services.displayManager.cosmic-greeter.package
          ];
      };

    };
}
