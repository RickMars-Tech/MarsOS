# Based on:
#   - https://github.com/JPyke3/hytale-launcher-nix
#   - https://github.com/visoredkon/hytale-launcher-flake
{ pkgs }:

let
  inherit (pkgs) lib;

  source = import ./source.nix;
  inherit (source) version sha256;

  app = {
    pname = "hytale-launcher";
    appId = "com.hypixel.HytaleLauncher";
    apiUrl = "https://launcher.hytale.com/version/release/launcher.json";
    description = "Official launcher for Hytale";
    desktopFileName = "com.hypixel.HytaleLauncher.desktop";
    execName = "hytale-launcher";
    homepage = "https://hytale.com";
    iconName = "com.hypixel.HytaleLauncher";
    iconSizes = [
      32
      48
      64
      128
      256
    ];
    metainfoFileName = "com.hypixel.HytaleLauncher.metainfo.xml";
  };

  meta = {
    inherit (app) description homepage;
    license = lib.licenses.unfree;
    mainProgram = app.execName;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [
      {
        name = "Jacob Pyke";
        email = "github@pyk.ee";
        github = "JPyke3";
        githubId = 13283054;
      }
      {
        name = "visoredkon";
        github = "visoredkon";
        githubId = 53637898;
      }
    ];
  };

  # Pinned launcher binary, downloaded at build time (no patching: it runs
  # unmodified inside the FHS sandbox, which keeps self-update working).
  unwrapped = pkgs.stdenvNoCC.mkDerivation {
    pname = "${app.pname}-unwrapped";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/${app.pname}-${version}.zip";
      inherit sha256;
    };

    nativeBuildInputs = [ pkgs.unzip ];

    unpackPhase = ''
      runHook preUnpack
      # The official archive carries leading padding, which makes unzip exit
      # non-zero on a benign warning; validate the extracted binary instead.
      unzip -q "$src" -d . || true
      if [ ! -f hytale-launcher ]; then
        echo "error: hytale-launcher not found in archive" >&2
        exit 1
      fi
      runHook postUnpack
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 hytale-launcher "$out/lib/${app.pname}/hytale-launcher"
      runHook postInstall
    '';

    meta = meta // {
      description = "${app.description} (unwrapped)";
    };
  };

  # Desktop integration assets extracted from the official Flatpak: desktop
  # entry, AppStream metainfo and the hicolor icon set.
  assets = pkgs.runCommand "${app.pname}-assets" { } ''
    install -Dm644 ${./assets}/${app.desktopFileName} \
      $out/share/applications/${app.desktopFileName}

    install -Dm644 ${./assets}/${app.metainfoFileName} \
      $out/share/metainfo/${app.metainfoFileName}

    ${lib.concatMapStrings (size: ''
      install -Dm644 ${./assets/icons/${toString size}.png} \
        $out/share/icons/hicolor/${toString size}x${toString size}/apps/${app.iconName}.png
    '') app.iconSizes}
  '';

  # Runtime wrapper: seeds the user data dir from the pinned binary, then tries
  # to fetch a newer release from the official API (SHA-256 verified).
  wrapper = pkgs.writeShellApplication {
    name = "${app.pname}-wrapper";

    runtimeInputs = with pkgs; [
      coreutils
      curl
      jq
      unzip
    ];

    text = ''
      API_URL="${app.apiUrl}"
      BUNDLED_VERSION="${version}"
      BUNDLED_BIN="${unwrapped}/lib/${app.pname}/hytale-launcher"
      LAUNCHER_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/Hytale"
      LAUNCHER_BIN="$LAUNCHER_DIR/hytale-launcher"
      VERSION_FILE="$LAUNCHER_DIR/.launcher_version"
      LAUNCHER_LOG="$LAUNCHER_DIR/launcher-wrapper.log"
      LAUNCHER_TMP="$LAUNCHER_DIR/.nix-tmp"

      curl_retry() {
        curl --retry 5 --retry-delay 2 --retry-all-errors --connect-timeout 10 "$@"
      }

      log() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LAUNCHER_LOG" 2>/dev/null || true
      }

      log_warn() {
        log "WARN: $1"
        echo "Warning: $1" >&2
      }

      fail() {
        log "ERROR: $1"
        echo "Error: $1" >&2
        if command -v notify-send >/dev/null 2>&1; then
          notify-send -u critical "Hytale Launcher Error" "$1"
        fi
        exit 1
      }

      exec_launcher() {
        # Enable GLib TLS backend and trust store.
        export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules"
        export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

        # WebKit/NVIDIA Wayland workarounds (upstream requirement).
        export WEBKIT_DISABLE_COMPOSITING_MODE=1
        export WEBKIT_DISABLE_DMABUF_RENDERER=1
        export __NV_DISABLE_EXPLICIT_SYNC=1

        # Hybrid GPU offloading: auto-detect NVIDIA, otherwise prime the
        # secondary GPU only when more than one render node is present.
        if [ -d /proc/driver/nvidia ] || command -v nvidia-smi >/dev/null 2>&1; then
          export __NV_PRIME_RENDER_OFFLOAD=1
          export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
          export __GLX_VENDOR_LIBRARY_NAME=nvidia
          export __VK_LAYER_NV_optimus=NVIDIA_only
        else
          shopt -s nullglob
          render_nodes=(/dev/dri/renderD*)
          if [ "''${#render_nodes[@]}" -gt 1 ]; then
            export DRI_PRIME=1
          fi
        fi

        # Keep patch staging on the same filesystem as the launcher data.
        unset XDG_CACHE_HOME
        export TMPDIR="$LAUNCHER_TMP"

        exec "$LAUNCHER_BIN" "$@"
      }

      mkdir -p "$LAUNCHER_DIR" "$LAUNCHER_TMP" || fail "cannot create $LAUNCHER_DIR"

      # Seed the writable copy from the pinned store binary when missing
      # (required for the launcher's self-update to work).
      if [ ! -x "$LAUNCHER_BIN" ]; then
        install -m755 "$BUNDLED_BIN" "$LAUNCHER_BIN" || fail "cannot install bundled launcher"
        echo "$BUNDLED_VERSION" > "$VERSION_FILE"
      fi

      have_version=""
      if [ -f "$VERSION_FILE" ]; then
        have_version="$(cat "$VERSION_FILE")"
      fi

      api_data="$(curl_retry -fsSL "$API_URL" 2>/dev/null || true)"
      if [ -z "$api_data" ]; then
        log_warn "could not fetch launcher metadata, using cached binary ($have_version)"
        exec_launcher "$@"
      fi

      want_version="$(jq -r '.version // ""' <<<"$api_data" || true)"
      want_sha="$(jq -r '.download_url.linux.amd64.sha256 // ""' <<<"$api_data" || true)"
      zip_url="$(jq -r '.download_url.linux.amd64.url // ""' <<<"$api_data" || true)"

      if [ -z "$want_version" ] || [ -z "$want_sha" ] || [ -z "$zip_url" ]; then
        log_warn "incomplete launcher metadata, using cached binary ($have_version)"
        exec_launcher "$@"
      fi

      if [ "$have_version" != "$want_version" ]; then
        workdir="$(mktemp -d "$LAUNCHER_TMP/hytale-XXXXXX")"

        if curl_retry -fsSL -o "$workdir/launcher.zip" "$zip_url" \
          && echo "$want_sha  $workdir/launcher.zip" | sha256sum -c - >/dev/null 2>&1; then
          # unzip exits non-zero on benign warnings (e.g. trailing archive
          # padding), so only validate the extracted binary.
          unzip -o -j "$workdir/launcher.zip" -d "$workdir" >/dev/null 2>&1 || true

          if [ -f "$workdir/hytale-launcher" ]; then
            install -m755 "$workdir/hytale-launcher" "$LAUNCHER_BIN" || fail "cannot install launcher"
            echo "$want_version" > "$VERSION_FILE"
            log "updated launcher to $want_version"
            rm -rf "$workdir"
          else
            rm -rf "$workdir"
            log_warn "extracted archive missing launcher binary, using cached binary ($have_version)"
            exec_launcher "$@"
          fi
        else
          rm -rf "$workdir"
          log_warn "failed to update to $want_version, using cached binary ($have_version)"
          exec_launcher "$@"
        fi
      fi

      exec_launcher "$@"
    '';
  };

  fhs = pkgs.buildFHSEnv {
    name = app.execName;
    inherit meta;

    runScript = lib.getExe wrapper;

    targetPkgs =
      pkgs: with pkgs; [
        # GTK / WebKit stack (launcher UI)
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        gdk-pixbuf
        glib
        glib-networking
        gtk3
        harfbuzz
        libsoup_3
        pango
        webkitgtk_4_1

        # Graphics (OpenGL / Vulkan / EGL, used by the game client via SDL3)
        egl-wayland
        libGL
        libGLU
        libglvnd
        mesa
        vulkan-loader

        # X11 (SDL3 dlopens these)
        libX11
        libXau
        libxcb
        libXcomposite
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libXinerama
        libXrandr
        libXrender
        libxscrnsaver
        libxshmfence
        libxxf86vm

        # Wayland
        libxkbcommon
        wayland

        # Audio
        alsa-lib
        libpulseaudio
        pipewire
        pulseaudio
        sdl3

        # System / runtime
        brotli
        bzip2
        cacert
        dbus
        elfutils
        expat
        fontconfig
        freetype
        fribidi
        glibc
        icu
        keyutils
        krb5
        libcap
        libffi
        libgcrypt
        libgpg-error
        libidn2
        libpsl
        libseccomp
        libunistring
        libunwind
        nettle
        nspr
        nss
        numactl
        openssl
        p11-kit
        stdenv.cc.cc.lib
        systemd
        util-linux
        xz
        zlib
        zstd

        # Multimedia codecs / GStreamer (WebKit media)
        dav1d
        flac
        gst_all_1.gst-plugins-base
        gst_all_1.gstreamer
        lame
        lcms2
        libaom
        libavif
        libjpeg
        libjxl
        libmpg123
        libogg
        libopus
        libpng
        libsndfile
        libvorbis
        libwebp
        libxml2
        libxslt
        orc
        woff2

        # Misc helpers
        enchant_2
        graphite2
        hyphen
        json-glib
        libgudev
        libmanette
        libnotify
        libproxy
        libsecret
        libthai
        pixman
        pcre2
        tinysparql
        udev
        xdg-utils

        # Runtime wrapper
        wrapper
      ];
  };
  hytale-launcher = pkgs.symlinkJoin {
    name = app.pname;

    paths = [
      fhs
      assets
    ];

    inherit meta;
  };
in
{
  inherit hytale-launcher;
  hytale-launcher-unwrapped = unwrapped;
}
