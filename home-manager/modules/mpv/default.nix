{ pkgs, ... }: {

    programs.mpv = {
        enable = true;
        config = {
    # ===== General
            border = "no";
            hls-bitrate = "max";
            keep-open = true;
            prefetch-playlist = true;
            save-position-on-quit = true;
            snap-window = true;
            autofit = "85%x85%";

    # ===== Audio
            volume = 100;
            volume-max = 100;
            mute = "no";
            audio-file-auto = "fuzzy"; # Load additional audio files containing the video filename

    # ===== Video
            #vo = "gpu";
            hwdec = "no"; #"vaapi"; #"auto-safe";
            pause = "no";
            profile = "gpu-hq";
            gpu-context = "wayland";
            gpu-api = "vulkan";
            vulkan-queue-count = 4;
            video-sync = "display-resample";
            interpolation = true;
            tscale = "oversample";
            fullscreen = false;

    # ===== RAM
            cache = "yes"; # uses a large seekable RAM cache even for local input.
            cache-secs = 300; # uses extra large RAM cache (needs cache=yes to make it useful).

    # ===== Subs
            sub-font = "Manrope-Semibold";
            sub-font-size = 40;
            sub-auto = "fuzzy"; # Load additional subtitle files containing the video filename
            demuxer-mkv-subtitle-preroll = "yes"; # Try to correctly show embedded subs when seeking
            slang = "spa,es"; # Prioritise which subtitles language to use

    # ===== Screenshots
    # %X is the fallback path if the video is not on the filesystem, like YouTube streams.
            screenshot-format = "png";
            screenshot-tag-colorspace = "yes"; # Tag screenshots with the appropriate colorspace
            screenshot-png-compression = 5;

    # ===== OSC
            osc = "no";
            osd-on-seek = "no";
            osd-bar = "no";
            osd-bar-w = 30;
            osd-bar-h = "0.2";
            osd-duration = 750;

    # ===== Terminal
            cursor-autohide = 100; # autohides the cursor after x ms
            cursor-autohide-fs-only = "yes"; # don't autohide the cursor in window mode, only fullscreen
            msg-color = "yes"; # color log messages on terminal
            msg-module = "yes"; # prepend module name to log messages
            term-osd-bar = "yes"; # displays a progress bar on the terminal
        };

        bindings = {
            "ctrl+a" = "script-message osc-visibility cycle";
            UP = "add volume +5";
            DOWN = "add volume -5";
        };
        scripts = with pkgs.mpvScripts; [
            mpris
            uosc
            thumbfast
            sponsorblock
        ];
    };
}
