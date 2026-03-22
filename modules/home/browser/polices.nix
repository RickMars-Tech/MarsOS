{
  programs.firefox.policies = {
    # Updates & Background Services
    AppAutoUpdate = false;
    BackgroundAppUpdate = false;

    # Access Restrictions
    BlockAboutConfig = false;
    BlockAboutProfiles = true;
    BlockAboutSupport = true;

    # UI and Behavior
    DisplayMenuBar = "never";
    DontCheckDefaultBrowser = true;
    HardwareAcceleration = false;
    OfferToSaveLogins = false;
    DefaultDownloadDirectory = "$HOME/Downloads";

    # Feature Disabling
    DisableFirefoxScreenshots = true;
    DisableMasterPasswordCreation = false;
    DisablePasswordReveal = true;
    DisablePocket = true;
    DisableSafeMode = false;
    DisableSecurityBypass = false;
    DisableTelemetry = true;
    DNSOverHTTPS = true;
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
    NoDefaultBookmarks = true;
    OfferToSaveLoginsDefault = false;
    PasswordManagerEnabled = false;
    PrimaryPassword = false;
    DisableFirefoxStudies = true;
    DisableFirefoxAccounts = false; # Enable FirefoxAccounts
    DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "never"
  };
}
