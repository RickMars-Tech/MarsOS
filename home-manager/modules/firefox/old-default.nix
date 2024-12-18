{ config, pkgs, lib, inputs, ... }: {

    programs.firefox = {                  
        enable = true;
        policies = {
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
            };
            PasswordManagerEnabled = false;
            OfferToSaveLoginsDefault = false;
            NoDefaultBookmarks = true;
            DisableFirefoxScreenshots = true;
        };
        profiles.rick = {
            isDefault = true;
            settings = {
            # Firefox Hardening File, from:
            # https://github.com/pyllyukko/user.js/blob/master/user.js

            # Disable about:config warning
                "browser.aboutConfig.showWarning" = false;

            # SECTION: Misc
                "network.cookie.cookieBehavior" = 1;
                "intl.accept_languages" = "es-MX, es";
                "clipboard.autocopy" = true;
                "keyword.enabled" = true;
                "browser.urlbar.trimURLs" = false;
                "browser.urlbar.speculativeConnect.enabled" = false;
                "network.proxy.socks_remote_dns" = true;
                "network.manage-offline-status" = false;
                "security.mixed_content.block_active_content" = true;
                "security.mixed_content.block_display_content" = true;
                "security.fileuri.strict_origin_policy" = true;
                "browser.urlbar.filter.javascript" = true;
                "javascript.options.asmjs" = false;
                "browser.display.use_document_fonts" = 0;
                "network.protocol-handler.warn-external-default" = true;
                "network.protocol-handler.external.javascript" = false;
                "network.protocol-handler.external.data" = false;
                "network.protocol-handler.expose-all" = false;

            # SECTION: HTML5 / APIs / DOM
                "dom.webnotifications.enabled" = false;
                "dom.enable_performance" = true;
                "dom.webaudio.enabled" = true;
                "geo.enabled" = false;
                "dom.netinfo.enabled" = false;
                "beacon.enabled" = false;
                "dom.event.clipboardevents.enabled" = false;
                "dom.allow_cut_copy" = false;
                "device.sensors.enabled" = false;
                "browser.send_pings" = false;
                "browser.send_pings.require_same_host" = true;
                "dom.gamepad.enabled" = false;
                "dom.vr.enabled" = false;
                "dom.vibrator.enabled" = false;
                "dom.maxHardwareConcurrency" = 4;
                "javascript.options.wasm" = false;

            # SECTION: Extensions / plugins
                "security.dialog_enable_delay" = 1000;
                "extensions.getAddons.cache.enabled" = false;
                "extensions.update.enabled" = true;
                "extensions.blocklist.enabled" = true;
                "extensions.systemAddon.update.enabled" = false;

            # SECTION: Firefox (anti-)features / components / Firefox Telemetry
                "devtools.debugger.remote-enabled" = true;
                "devtools.debugger.force-local" = true;
                "toolkit.telemetry.unified" = false;
                "toolkit.telemetry.archive.enabled" = false;
                "breakpad.reportURL" = "";
                "browser.tabs.crashReporting.sendReport" = false;
                "browser.crashReports.unsubmittedCheck.enabled" = false;
                "browser.uitour.enabled" = false;
                "browser.sessionstore.privacy_level" = 2;
                "privacy.userContext.enabled" = true;
                "privacy.resistFingerprinting" = true;
                "privacy.resistFingerprinting.block_mozAddonManager" = true;
                "extensions.webextensions.restrictedDomains" = "";
                "browser.startup.blankWindow" = false;
                "pdfjs.disabled" = true;
                "datareporting.healthreport.uploadEnabled" = false;
                "datareporting.policy.dataSubmissionEnabled" = false;
                "app.normandy.enabled" = false;
                "app.normandy.api_url" = "";
                "app.shield.optoutstudies.enabled" = false;
                "browser.safebrowsing.phishing.enabled" = true;
                "browser.safebrowsing.malware.enabled" = true;
                "browser.safebrowsing.downloads.remote.enabled" = false;
                "extensions.pocket.enabled" = false;
                "privacy.globalprivacycontrol.enabled" = true;

            # SECTION: Automatic connections
                "network.dns.blockDotOnion" = true;
                "browser.search.suggest.enabled" = false;
                "browser.urlbar.suggest.searches" = false;
                "browser.urlbar.suggest.history" = false;
                "browser.urlbar.groupLabels.enabled" = false;
                "network.http.speculative-parallel-limit" = 6;
                "browser.search.update" = false;
                "network.captive-portal-service.enabled" = false;
                "browser.topsites.contile.enabled" = false;
                "browser.newtabpage.activity-stream.feeds.topsites" = false;

            # SECTION: HTTP
                "network.http.http3.enable" = false;
                "network.http.http3.ebable_0rtt" = false;
                "network.http.http3.ebable_kyber" = false;
                "network.http.http3.ebable_qlog" = false;
                "network.http.referer.XOriginPolicy" = 2;
                "network.http.referer.trimmingPolicy" = 2;
                "network.http.referer.XOriginTrimmingPolicy" = 2;
                "privacy.firstparty.isolate" = true;

            # SECTION: Geolocation
                "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
                "geo.provider.use_geoclue" = false;

            # SECTION: UI related
                "devtools.chrome.enabled" = false;
                "layout.css.prefers-color-scheme.content-override" = 2;
                "browser.theme.content-theme" = 2;
                "browser.theme.toolbar-theme" = 1;
                "browser.compactmode.show" = true;
                "ui.key.menuAccessKeyFocuses" = false;
                "browser.download.folderList" = 2;
                "browser.download.useDownloadDir" = false;
                "browser.newtabpage.enabled" = false;
                "browser.newtab.url" = "about:blank";
                "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                "browser.newtabpage.activity-stream.telemetry" = false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
                "browser.newtabpage.activity-stream.showSponsored" = false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                "browser.newtabpage.activity-stream.default.sites" = "";
                "browser.newtab.preload" = false;
                "browser.vpn_promo.enabled" = false;
                "network.IDN_show_punycode" = true;
                "layout.css.visited_links_enabled" = false;
                "browser.privatebrowsing.vpnpromourl" = "";
                "extensions.htmlaboutaddons.recommendations.enabled" = false;
                "browser.discovery.enabled" = false;
                "browser.shell.checkDefaultBrowser" = false;
                "browser.preferences.moreFromMozilla" = false;
                "browser.aboutwelcome.enabled" = false;
                "browser.tabs.tabmanager.enabled" = false;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "layout.css.light-dark.enabled" = true;
                "browser.theme.dark-private-windows" = true;
                "cookiebanners.service.mode" = 0;
                "cookiebanners.service.mode.privateBrowsing" = 0;
                "browser.urlbar.suggest.engines" = false;

            # SECTION: Cryptography
                "dom.security.https_only_mode" = true;
                "network.stricttransportsecurity.preloadlist" = true;
                "security.OCSP.enabled" = 1;
                "security.ssl.enable_ocsp_stapling" = true;
                "security.ssl.enable_ocsp_must_staple" = true;
                "security.OCSP.require" = true;
                "security.ssl.disable_session_identifiers" = true;
                "security.tls.version.min" = 3;
                "security.tls.version.max" = 4;
                "security.tls.version.fallback-limit" = 4;
                "security.cert_pinning.enforcement_level" = 2;
                "security.ssl.treat_unsafe_negotiation_as_broken" = true;

            # SECTION: Cipher suites
                "security.ssl3.ecdhe_rsa_aes_128_sha" = false;
                "security.ssl3.ecdhe_ecdsa_aes_128_sha" = false;
                "security.ssl3.dhe_rsa_aes_128_sha" = false;
                "security.ssl3.ecdhe_ecdsa_aes_128_gcm_sha256" = true;
                "security.ssl3.ecdhe_rsa_aes_128_gcm_sha256" = true;
                "security.ssl3.ecdhe_ecdsa_chacha20_poly1305_sha256" = true;
                "security.ssl3.ecdhe_rsa_chacha20_poly1305_sha256" = true;
                "security.ssl3.dhe_rsa_aes_256_sha" = false;
                "security.tls.enable_kyber" = true;

            # GFX / WebGL / Media
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

            # XDG-Portal
                "widget.use-xdg-desktop-portal.file-picker" = 1;
                "widget.use-xdg-desktop-portal.mime-handler" = 1;

            };
        };
        package = (pkgs.wrapFirefox (pkgs.firefox-beta-unwrapped.override { pipewireSupport = true;}) {});
    };
}
