{
  pkgs,
  username,
  ...
}: {
  programs.firefox = {
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {}; #pkgs.firefox-wayland;
    enable = true;
    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked";

        # UblockOrigin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # MalwareBytes
        "{242af0bb-db11-4734-b7a0-61cb8a9b20fb}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/malwarebytes/latest.xpi";
          installation_mode = "force_installed";
        };

        # User-Agent Switcher and Manager
        "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/user-agent-string-switcher/latest.xpi";
          installation_mode = "force_installed";
        };

        # OneTab
        "extension@one-tab.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/onetab/latest.xpi";
          installation_mode = "force_installed";
        };

        # ImprovedTube
        "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-addon/latest.xpi";
          installation_mode = "force_installed";
        };

        # Bitwarden Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };

        # Auto Tab Discard
        "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
          installation_mode = "force_installed";
        };

        # DarkReader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };

        # TWP (Translate Web Pages)
        "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
          installation_mode = "force_installed";
        };

        # SponsorBlock
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      #|==< Polices >==|#
      AppAutoUpdate = false;
      BlockAboutConfig = false;
      DisableFirefoxScreenshots = true;
      DisableMasterPasswordCreation = false;
      DisablePasswordReveal = true;
      DisablePocket = true;
      DisableSafeMode = false;
      DisableSecurityBypass = true;
      DisableTelemetry = true;
      DNSOverHTTPS = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
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
      SearchBar = "unified"; # alternative: "separate"
    };
    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        force = true;
        engines = {
          # don't need these default ones
          "amazondotcom-us".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ebay".metaData.hidden = true;
          "Startpage" = {
            urls = [
              {
                template = "https://www.startpage.com/sp/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [",d"];
          };
          "Home Manager Options" = {
            urls = [
              {
                template = "https://mipmip.github.io/home-manager-option-search/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["ho"];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["np"];
          };
          "youtube" = {
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["y"];
          };
          "Wikipedia" = {
            urls = [
              {
                template = "https://en.wikipedia.org/wiki/Special:Search";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["wik"];
          };
          "GitHub" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["gh"];
          };
        };
        default = "Startpage";
      };
      containersForce = true;
      containers = {
        sinenomine = {
          id = 1;
          icon = "chill";
          color = "purple";
        };
        nublado = {
          id = 2;
          icon = "chill";
          color = "blue";
        };
      };
      settings = {
        "ui.key.menuAccessKeyFocuses" = false;
        # Dont clean cookies
        "privacy.clearOnShutdown.cookie" = false;
        "privacy.sanitize.sanitizeOnShutdown" = false;
        # settings = lib.mapAttrs' (n: lib.nameValuePair "pref.${n}") {
        "app.update.auto" = true; # disable auto update
        "dom.security.https_only_mode" = true; # force https
        "extensions.pocket.enabled" = false; # disable pocket
        "browser.quitShortcut.disabled" = true; # disable ctrl+q
        "browser.download.panel.shown" = true; # show download panel
        "signon.rememberSignons" = false; # disable saving passwords
        "identity.fxaccounts.enabled" = true; # Enable librewolf accounts
        "app.shield.optoutstudies.enabled" = false; # disable shield studies
        "browser.shell.checkDefaultBrowser" = false; # don't check if default browser
        "browser.bookmarks.restore_default_bookmarks" = false; # don't restore default bookmarks
        # Download handling
        "browser.download.dir" = "/home/${username}/Downloads"; # default download dir
        "browser.startup.page" = 3; # restore previous session
        "browser.sessionstore.resume_from_crash" = true;
        # UI changes
        "layout.css.prefers-color-scheme.content-override" = 2;
        # Vertical Tabs
        "sidebar.verticalTabs" = true;
        # "browser.uidensity" = 1; # enable dense UI
        "general.autoScroll" = true; # enable autoscroll
        "browser.compactmode.show" = true; # enable compact mode
        # "browser.tabs.firefox-view" = false; # enable librewolf view
        "startup.homepage_welcome_url" = ""; # disable welcome page
        "browser.newtabpage.enabled" = false; # disable new tab page
        "full-screen-api.ignore-widgets" = true; # fullscreen within window
        #"browser.toolbars.bookmarks.visibility" = "newtab"; # only show bookmarks toolbar on new tab
        "browser.aboutConfig.showWarning" = false; # disable warning about about:config
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = true; # disable picture in picture button
        "browser.newtabpage.activity-stream.showWeather" = false;

        # Privacy/Security
        "security.mixed_content.block_active_content" = true; # Block mixed content
        "media.peerconnection.enabled" = false; # Disable WebRTC
        "browser.discovery.enabled" = false; # disable discovery
        "browser.search.suggest.enabled" = false; # disable search suggestions
        "browser.contentblocking.category" = "custom"; # set tracking protection to custom
        "dom.private-attribution.submission.enabled" = false; # stop doing dumb stuff mozilla
        "browser.protections_panel.infoMessage.seen" = true; # disable tracking protection info
        "permissions.default.desktop-notification" = 0; # block notifications to increase security and minimize annoyances.
        "privacy.resistFingerprinting" = true; # Enable fingerprinting resistance

        # Disable telemetry
        "toolkit.telemetry.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "toolkit.telemetry.unified" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "browser.translations.automaticallyPopup" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;

        # let me close and open tabs without confirmation
        "browser.tabs.loadInBackground" = true; # open new tab in background
        "browser.tabs.loadBookmarksInTabs" = true; # open bookmarks in new tab
        "browser.tabs.warnOnOpen" = false; # don't warn when opening multiple tabs
        "browser.tabs.warnOnQuit" = false; # don't warn when closing multiple tabs
        "browser.tabs.warnOnClose" = false; # don't warn when closing multiple tabs
        "browser.tabs.loadDivertedInBackground" = false; # open new tab in background
        "browser.tabs.warnOnCloseOtherTabs" = false; # don't warn when closing multiple tabs
        "browser.tabs.closeWindowWithLastTab" = false; # don't close window when last tab is closed

        # other
        "media.autoplay.default" = 0; # enable autoplay on open
        "devtools.toolbox.host" = "right"; # move devtools to right
        # "browser.ssb.enabled" = true; # enable site specific browser
        "devtools.cache.disabled" = true; # disable caching in devtools

        # Fonts
        "font.size.fixed.x-western" = 15;
        "font.size.variable.x-western" = 15;
        "font.size.monospace.x-western" = 15;
        "font.minimum-size.x-western" = 13;
        "browser.display.use_document_fonts" = 1;
        "browser.link.open_newwindow.restriction" = 0;

        "browser.fixup.domainsuffixwhitelist.home" = true;
        "browser.fixup.domainwhitelist.server.home" = true;
        # "keyword.enable" = false; # Disable search when typing unexistent TLD

        # Linux
        "gfx.webrender.software.opengl" = true;
        # prefer GPU over CPU
        "layers.gpu-process.force-enabled" = false;
        # Putting the Firefox network cache into the RAM
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true; # https://kb.mozillazine.org/Browser.cache.memory.enable
        "browser.cache.memory.capacity" = 524288; # which equals a maximum of 512 MB
        # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
        # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
        # then have Firefox open on some other workspace.
        "widget.disable-workspace-management" = true;
        # XDG-Portal
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;

        # Rendering/Performance
        "webgl.force-enabled" = false;
        "webgl.msaa-force" = false;
        "gfx.webrender.software" = true;
        "gfx.canvas.disabled" = true;
        "dom.ipc.processCount" = 6;
        "browser.preferences.defaultPerformanceSettings.enabled" = false;
        "browser.sessionstore.interval" = 600000;

        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;
        "gfx.font_rendering.opentype_svg.enabled" = true;
        "gfx.webrender.all" = true;
        "webgl.disabled" = false;
        "webgl.min_capability_mode" = false;
        "webgl.disable-extensions" = false;
        "webgl.disable-fail-if-major-performance-caveat" = false;
        "webgl.enable-debug-renderer-info" = false;
        "media.video_stats.enabled" = false;
        "media.peerconnection.ice.no_host" = true;
        "media.navigator.enabled" = false;
        "media.navigator.video.enabled" = false;
        "media.getusermedia.screensharing.enabled" = false;
        "media.webspeech.recognition.enable" = false;
        "media.webspeech.synth.enabled" = false;
        "media.gmp-gmpopenh264.enabled" = true;
        "media.gmp-manager.url" = "";
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;
      };
    };
  };
}
