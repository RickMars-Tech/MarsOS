{
  programs.firefox.policies = {
    # Extensions = import ./extensions.nix;
    DefaultDownloadDirectory = "\${home}/Downloads";
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
    FirefoxHome = {
      Search = true;
      TopSites = false;
      SponsoredPocket = false;
      Pocket = false;
      Snippets = false;
      SponsoredTopSites = false;
      Highlights = false;
    };
    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
    };
    UserMessaging = {
      ExtensionRecommendations = false;
      UrlbarInterventions = false;
      SkipOnboarding = true;
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
}
