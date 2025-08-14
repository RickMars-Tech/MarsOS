_: {
  programs.firefox.profiles.default.settings = {
    # Disable AI Trash
    "browser.ml.chat.enabled" = false; # Disable AI Chats
    "browser.ml.chat.hideLocalhost" = false;
    "browser.ml.chat.menu" = false;
    "browser.tabs.groups.smart.enabled" = false;

    "ui.key.menuAccessKeyFocuses" = false; # Disable ALT Menu
    # Vertical Tabs
    "sidebar.verticalTabs" = true;
    "sidebar.visibility" = "never-show";
    "sidebar.revamp" = true;
    "sidebar.main.tools" = "";
    # "browser.compactmode.show" = true; # enable compact mode
    "startup.homepage_welcome_url" = "about:home"; # disable welcome page
    "browser.newtabpage.enabled" = false; # disable new tab page

    "browser.startup.page" = 3; # restore previous session
    "browser.sessionstore.resume_from_crash" = true;

    # XDG-Portal (0= Disable, 1= Enable, 2= Auto)
    "widget.use-xdg-desktop-portal.file-picker" = 2;
    "widget.use-xdg-desktop-portal.mime-handler" = 2;
    # To prevent duplicate entries in the Media Player widget or tray icon
    "media.hardwaremediakeys.enabled" = false;

    # GENERAL/Common
    "content.notify.interval" = 100000;
    "browser.sessionstore.max_resumed_crashes" = 0;
    "toolkit.cosmeticAnimations.enabled" = false; # Disable Unnecesary Animations
    "config.trum_on_minimize" = true;

    # GFX
    "gfx.canvas.accelerated.cache-size" = 512;
    "gfx.content.skia-font-cache-size" = 20;

    #==< CACHE >==#
    # DiskCache
    "browser.cache.disk.enable" = false;
    # MEMORY CACHE
    "browser.sessionhistory.max_total_viewers" = 4;
    "browser.sessionhistory.max_entries" = 25;
    # MEDIA CACHE
    "media.memory_cache_max_size" = 65536;
    "media.cache_readahead_limit" = 7200;
    "media.cache_resume_threshold" = 3600;

    #IMAGE CACHE
    "image.mem.decode_bytes_at_a_time" = 32768;

    #NETWORK

    "network.http.max-connections" = 1800;
    "network.http.max-persistent-connections-per-server" = 10;
    "network.http.max-urgent-start-excessive-connections-per-host" = 5;
    "network.http.pacing.requests.enabled" = false;
    "network.dnsCacheExpiration" = 3600;
    "network.ssl_tokens_cache_capacity" = 10240;

    #SPECULATIVE LOADING
    "network.http.speculative-parallel-limit" = 0;
    "network.dns.disablePrefetch" = true;
    "network.dns.disablePrefetchFromHTTPS" = true;
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.places.speculativeConnect.enabled" = false;
    "network.prefetch-next" = false;
    "network.predictor.enabled" = false;

    #EXPERIMENTAL
    "layout.css.grid-template-masonry-value.enabled" = true;

    # **************************************************************************
    # * SECTION: SECUREFOX                                                     *
    # **************************************************************************

    #TRACKING PROTECTION

    "browser.contentblocking.category" = "strict";
    "browser.download.start_downloads_in_tmp_dir" = true;
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.uitour.enabled" = false;
    "privacy.globalprivacycontrol.enabled" = true;

    #OCSP & CERTS / HPKP

    "security.OCSP.enabled" = 0;
    "security.pki.crlite_mode" = 2;

    #SSL / TLS

    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "browser.xul.error_pages.expert_bad_cert" = true;
    "security.tls.enable_0rtt_data" = false;

    #DISK AVOIDANCE

    "browser.privatebrowsing.forceMediaMemoryCache" = true;
    "browser.sessionstore.interval" = 60000;

    /**
    SHUTDOWN & SANITIZING **
    */
    # "browser.privatebrowsing.resetPBM.enabled" = true;
    # "privacy.history.custom" = true;

    /**
    SEARCH / URL BAR **
    */
    "browser.urlbar.trimHttps" = true;
    "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
    "browser.search.separatePrivateDefault.ui.enabled" = true;
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.quicksuggest.enabled" = false;
    "browser.urlbar.groupLabels.enabled" = false;
    "browser.formfill.enable" = false;
    "network.IDN_show_punycode" = true;

    /**
    PASSWORDS **
    */
    # "signon.formlessCapture.enabled" = false;
    # "signon.privateBrowsingCapture.enabled" = false;
    # "network.auth.subresource-http-auth-allow" = 1;
    # "editor.truncate_user_pastes" = false;

    /**
    MIXED CONTENT + CROSS-SITE **
    */
    "security.mixed_content.block_display_content" = true;
    "pdfjs.enableScripting" = false;

    /**
    EXTENSIONS **
    */
    "extensions.enabledScopes" = 5;

    /**
    HEADERS / REFERERS **
    */
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    /**
    CONTAINERS **
    */
    "privacy.userContext.ui.enabled" = true;

    /**
    SAFE BROWSING **
    */
    "browser.safebrowsing.downloads.remote.enabled" = false;

    /**
    MOZILLA **
    */
    "permissions.default.desktop-notification" = 2;
    "permissions.default.geo" = 2;
    "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
    "browser.search.update" = false;
    "permissions.manager.defaultsUrl" = "";
    "extensions.getAddons.cache.enabled" = false;

    /*
    TELEMETRY
    */
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "datareporting.usage.uploadEnabled" = false;

    /**
    EXPERIMENTS **
    */
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    /**
    CRASH REPORTS **
    */
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;

    /**
      **************************************************************************
     * SECTION: PESKYFOX                                                        *
    ***************************************************************************
    */
    /**
    MOZILLA UI **
    */
    "browser.privatebrowsing.vpnpromourl" = "";
    # "extensions.getAddons.showPane" = false;
    # "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.preferences.moreFromMozilla" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;
    "browser.profiles.enabled" = true;

    /**
    THEME ADJUSTMENTS **
    */
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.compactmode.show" = true;
    # "browser.privateWindowSeparation.enabled" = false; # WINDOWS

    /**
    FULLSCREEN NOTICE **
    */
    "full-screen-api.transition-duration.enter" = "0 0";
    "full-screen-api.transition-duration.leave" = "0 0";
    "full-screen-api.warning.timeout" = 0;

    /**
    URL BAR **
    */
    "browser.urlbar.unitConversion.enabled" = true;
    "browser.urlbar.trending.featureGate" = false;

    /**
    NEW TAB PAGE **
    */
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;

    /**
    POCKET **
    */
    "extensions.pocket.enabled" = false;

    /**
    DOWNLOADS **
    */
    "browser.download.manager.addToRecentDocs" = false;

    /**
    PDF **
    */
    "browser.download.open_pdf_attachments_inline" = true;

    /**
    TAB BEHAVIOR **
    */
    "browser.bookmarks.openInTabClosesMenu" = false;
    "browser.menu.showViewImageInfo" = true;
    "findbar.highlightAll" = true;
    "layout.word_select.eat_space_to_next_word" = false;
  };
}
