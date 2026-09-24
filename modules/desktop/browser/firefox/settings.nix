{
  flake.modules.nixos.firefoxSettings = {
    programs.firefox = {
      preferencesStatus = "locked";
      preferences = {
        # disable libadwaita theming for Firefox
        "widget.gtk.libadwaita-colors.enabled" = false;

        "browser.shell.checkDefaultBrowser" = false;
        "extensions.autoDisableScopes" = 0;
        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.download.alwaysOpenPanel" = true;

        # Disable AI Trash
        "browser.ai.control.default" = "blocked";
        "browser.ai.control.linkPreviewKeyPoints" = "blocked";
        "browser.ai.control.pdfjsAltText" = "blocked";
        "browser.ai.control.sidebarChatbot" = "blocked";
        "browser.ai.control.smartTabGroups" = "blocked";
        "browser.ai.control.translations" = "blocked";
        "extensions.ml.enabled" = false;
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.menu" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.chat.hideLocalhost" = false;
        "browser.ml.chat.page.footerBadge" = false;
        "browser.ml.chat.page.menuBadge" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.ml.pageAssist.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;
        "browser.search.visualSearch.featureGate" = false;

        "gfx.webrender.layer-compositor" = true;
        # Speed up
        "media.wmf.zero-copy-nv12-textures-force-enable" = true;

        # disable prefetch
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.predictor.enable-prefetch" = false;
        "network.http.speculative-parallel-limit" = 0;

        # Harware Acceleration
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.av1.enabled" = true;

        # Desactiva software fallback
        "media.ffvpx.enabled" = false;
        "media.rdd-ffvpx.enabled" = false;

        # Dark mode
        "ui.systemUsesDarkTheme" = true;
        "widget.content.allow-gtk-dark-theme" = true;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "full-screen-api.ignore-widgets" = true;

        "ui.key.menuAccessKeyFocuses" = false; # Disable ALT Menu
        # Vertical Tabs & UX
        "sidebar.verticalTabs" = false;
        "sidebar.verticalTabs.dragToPinPromo.dismissed" = false;
        "sidebar.visibility" = "";
        "sidebar.revamp" = false;
        "sidebar.main.tools" = "";
        "browser.compactmode.show" = true; # enable compact mode
        "startup.homepage_welcome_url" = "about:home"; # disable welcome page
        "browser.newtabpage.enabled" = false; # disable new tab page
        "browser.tabs.inTitlebar" = 1;
        "browser.tabs.splitView.enabled" = false;

        "browser.startup.page" = 3; # restore previous session
        "browser.sessionstore.resume_from_crash" = true;

        "browser.cache.memory.enable" = false;
        "browser.tabs.unloadOnLowMemory" = true;

        # disable zoom with ctrl+mouse, https://support.mozilla.org/en-US/questions/1253302
        "mousewheel.with_control.action" = 1;

        # XDG-Portal (0= Disable, 1= Enable, 2= Auto)
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        # To prevent duplicate entries in the Media Player widget or tray icon
        "media.hardwaremediakeys.enabled" = false;
      };
    };
  };
}
