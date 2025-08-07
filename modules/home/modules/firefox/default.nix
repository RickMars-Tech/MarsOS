{
  pkgs,
  # username,
  ...
}: {
  programs.firefox = {
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {}; #pkgs.firefox-wayland;
    enable = true;
    policies = {
      ExtensionSettings = import ./extensions.nix;

      #|==< Polices >==|#
      AppAutoUpdate = false;
      BlockAboutConfig = false;
      DisableFirefoxScreenshots = true;
      DisableMasterPasswordCreation = false;
      DisablePasswordReveal = true;
      DisablePocket = true;
      DisableSafeMode = false;
      DisableSecurityBypass = false;
      DisableTelemetry = true;
      DNSOverHTTPS = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      HardwareAcceleration = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      PrimaryPassword = false;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = false; # Enable FirefoxAccounts
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "never"
      DisplayMenuBar = "never"; # alternatives: "always", "never" or "default-on"
    };
    profiles.default = import ./profile.nix;
  };
}
