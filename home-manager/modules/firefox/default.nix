{ pkgs, ... }: {

    programs.firefox = {                  
        enable = true;
        policies = {
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
        };
        profiles.default = {
            id = 0;
            name = "default";
            isDefault = true;
            settings = {
                # "browser.startup.homepage" = "https://duckduckgo.com";
                "browser.search.defaultenginename" = "DuckDuckGo";
                "browser.search.order.1" = "DuckDuckGo";

                "ui.key.menuAccessKeyFocuses" = false;
                "signon.rememberSignons" = false;
                "browser.aboutConfig.showWarning" = false;
                "browser.compactmode.show" = true;
                "browser.cache.disk.enable" = true;

                "mousewheel.default.delta_multiplier_x" = 50;
                "mousewheel.default.delta_multiplier_y" = 50;
                "mousewheel.default.delta_multiplier_z" = 50;

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

            # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
            # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
            # then have Firefox open on some other workspace.
                "widget.disable-workspace-management" = true;
            # XDG-Portal
                "widget.use-xdg-desktop-portal.file-picker" = 1;
                "widget.use-xdg-desktop-portal.mime-handler" = 1;
            };
            search = {
                force = true;
                default = "DuckDuckGo";
                order = [ "DuckDuckGo" "Google" ];
            };
        };
        package = pkgs.firefox;
    };
}
