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

      services.desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
        showExcludedPkgsWarning = false;
      };
      services.system76-scheduler.enable = config.services.desktopManager.cosmic.enable;
      hardware.system76.power-daemon.enable = config.services.desktopManager.cosmic.enable;

      # Extra Apps for Cosmic
      environment.systemPackages = with pkgs; [
        cosmic-ext-applet-sysinfo
        cosmic-ext-ctl
        cosmic-ext-calculator
        cosmic-ext-tweaks
        cutecosmic
        wl-clipboard-rs
      ];

      # Use oo7 instead of Gnome K-ring
      services.oo7.enable = true;
      services.gnome.gnome-keyring.enable = mkForce false;

      # Clipboard Fix
      environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

      # Excluded Packages
      environment.cosmic.excludePackages =
        with pkgs;
        [
          cosmic-edit
          cosmic-store
          cosmic-player
          # cosmic-term
          cosmic-greeter
        ]
        ++ optional (!config.services.displayManager.cosmic-greeter.enable) [
          cosmic-greeter
        ];

    };
}
