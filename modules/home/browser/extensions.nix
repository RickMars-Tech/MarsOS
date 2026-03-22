{lib, ...}: let
  inherit (lib) mkForce;
  extensions = [
    "ublock-origin"
    "bitwarden-password-manager"
    "sponsorblock"
    "spot-sponsorblock"
    "darkreader"
    "traduzir-paginas-web"
    "auto-tab-discard"
    "user-agent-string-switcher"
    "return-youtube-dislikes"
  ];
in {
  programs.firefox = {
    enable = true;
    policies = {
      Extensions.Install =
        map
        (ex: "https://addons.mozilla.org/firefox/downloads/latest/${ex}/latest.xpi")
        extensions;

      ExtensionSettings."*".installation_mode = "normal_installed";
      # Extension configuration
      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net".adminSettings = {
          userSettings = rec {
            uiTheme = "dark";
            uiAccentCustom = true;
            uiAccentCustom0 = "#8300ff";
            cloudStorageEnabled = mkForce false;

            importedLists = [
              "https:#filters.adtidy.org/extension/ublock/filters/3.txt"
              "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            ];

            externalLists = lib.concatStringsSep "\n" importedLists;
          };

          selectedFilterLists = [
            "CZE-0"
            "adguard-generic"
            "adguard-annoyance"
            "adguard-social"
            "adguard-spyware-url"
            "easylist"
            "easyprivacy"
            "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            "plowe-0"
            "ublock-abuse"
            "ublock-badware"
            "ublock-filters"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "urlhaus-1"
          ];
        };
      };
    };
  };
}
