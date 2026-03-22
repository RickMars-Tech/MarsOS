{
  lib,
  stdenv,
  buildFHSEnv,
  makeDesktopItem,
  symlinkJoin,
  fetchurl,
  writeShellScript,
  unzip,
  glib,
  gtk3,
  webkitgtk_4_1,
  gdk-pixbuf,
  libsoup_3,
  cairo,
  pango,
  harfbuzz,
  atk,
  at-spi2-atk,
  at-spi2-core,
  openssl,
  zlib,
  icu,
  libGL,
  libGLU,
  libglvnd,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libxcb,
  libXcursor,
  libXi,
  libXrender,
  libXtst,
  libXScrnSaver,
  libXinerama,
  libxshmfence,
  libXxf86vm,
  libxkbcommon,
  mesa,
  vulkan-loader,
  wayland,
  egl-wayland,
  pipewire,
  alsa-lib,
  pulseaudio,
  dbus,
  gsettings-desktop-schemas,
  hicolor-icon-theme,
  curl,
  patchelf,
  fontconfig,
  freetype,
  nspr,
  nss,
  systemd,
  krb5,
  glib-networking,
  cacert,
  gamemode,
  cups,
  expat,
  libxcrypt,
  libva,
  libdrm,
  libpng,
  xdg-utils,
  # Opciones configurables
  enableGamemode ? true,
}: let
  pname = "hytale-launcher";

  # Importar versión y hash desde source.nix
  source = import ./source.nix;
  version = source.version;

  # Unwrapped launcher - extract binary from zip
  unwrapped = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-${version}.zip";
      sha256 = source.sha256;
    };

    nativeBuildInputs = [unzip];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -Dm755 hytale-launcher $out/bin/hytale-launcher
      runHook postInstall
    '';

    meta = {
      description = "Hytale Launcher binary";
      platforms = ["x86_64-linux"];
    };
  };

  # FHS environment
  hytale-launcher-fhs = buildFHSEnv {
    name = pname;

    targetPkgs = pkgs:
      [
        # WebKit/GTK stack for launcher UI
        gtk3
        glib
        webkitgtk_4_1
        libsoup_3
        openssl
        gsettings-desktop-schemas
        glib-networking
        dbus
        pango
        cairo
        gdk-pixbuf
        atk
        at-spi2-atk
        at-spi2-core
        hicolor-icon-theme
        xdg-utils

        # Graphics stack
        cups
        icu
        zlib
        libpng
        freetype
        fontconfig
        harfbuzz
        nspr
        nss
        expat
        alsa-lib
        libxcrypt
        mesa
        vulkan-loader
        libGL
        libGLU
        libglvnd
        libva
        libdrm
        wayland
        egl-wayland
        libxkbcommon

        # Audio
        pipewire
        pulseaudio

        # X11 libraries
        libX11
        libXcomposite
        libXdamage
        libXext
        libXfixes
        libXrandr
        libxcb
        libXcursor
        libXi
        libXrender
        libXtst
        libXScrnSaver
        libXinerama
        libxshmfence
        libXxf86vm

        # System libraries
        systemd
        krb5
        cacert
        curl
        patchelf

        # C++ runtime
        stdenv.cc.cc.lib
      ]
      ++ lib.optional enableGamemode gamemode;

    profile = ''
      # Backend preference (Wayland with X11 fallback)
      export GDK_BACKEND="''${GDK_BACKEND:-wayland,x11}"

      # WebKit optimizations
      export WEBKIT_DISABLE_COMPOSITING_MODE=1

      # GTK/GLib schemas
      export XDG_DATA_DIRS="${lib.makeSearchPath "share/gsettings-schemas" [
        gsettings-desktop-schemas
        gtk3
      ]}:$XDG_DATA_DIRS"

      # Vulkan optimizations (always enabled)
      export __GL_GSYNC_ALLOWED="''${__GL_GSYNC_ALLOWED:-1}"
      export __GL_VRR_ALLOWED="''${__GL_VRR_ALLOWED:-1}"

      ${lib.optionalString enableGamemode ''
        # GameMode preload
        export LD_PRELOAD="${lib.getLib gamemode}/lib/libgamemodeauto.so.0''${LD_PRELOAD:+:$LD_PRELOAD}"
      ''}
    '';

    runScript = writeShellScript "hytale-run" ''
      set -euo pipefail

      # Path configuration
      DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/Hytale"
      LAUNCHER_DIR="$DATA_DIR/launcher"
      TARGET_BIN="$LAUNCHER_DIR/hytale-launcher"
      SOURCE_BIN="${unwrapped}/bin/hytale-launcher"

      mkdir -p "$LAUNCHER_DIR"

      # Copy launcher on first run or if source changed
      if [ ! -f "$TARGET_BIN" ] || [ "${unwrapped}/bin/hytale-launcher" -nt "$TARGET_BIN" ]; then
        echo "Installing/Updating Hytale Launcher (version ${version})..."
        cp -f "$SOURCE_BIN" "$TARGET_BIN"
        chmod +x "$TARGET_BIN"
        echo "Launcher ready!"
      fi

      # IPv6 check (always enabled - required for Netty QUIC)
      if [[ -z "''${HYTALE_SKIP_IPV6_CHECK:-}" ]]; then
        if [[ ! -d /proc/sys/net/ipv6 ]]; then
          echo "WARNING: Hytale requires IPv6 (Netty QUIC)." >&2
          echo "Enable IPv6 in your OS or set HYTALE_SKIP_IPV6_CHECK=1 to skip this check." >&2
        fi
      fi

      ${lib.optionalString enableGamemode ''
        # GameMode status
        if command -v gamemoded &> /dev/null; then
          echo "GameMode available - optimizations will be applied automatically"
          gamemoderun
        fi
      ''}

      # Run launcher
      cd "$LAUNCHER_DIR"
      exec "$TARGET_BIN" "$@"
    '';

    meta = with lib; {
      description = "Official Hytale game launcher";
      homepage = "https://hytale.com";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = pname;
    };
  };

  # Desktop entry
  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Hytale";
    genericName = "Voxel RPG";
    comment = "Adventure awaits in Orbis";
    exec = "${pname} %U";
    icon = pname;
    terminal = false;
    type = "Application";
    categories = ["Game" "ActionGame" "RolePlaying"];
    keywords = ["hytale" "game" "launcher" "voxel" "rpg"];
    startupNotify = true;
    startupWMClass = "hytale";
  };
in
  # Final package
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [hytale-launcher-fhs desktopItem];

    postBuild = ''
      # Install icon from local file
      for size in 256x256 128x128 64x64 48x48 32x32 16x16; do
        mkdir -p $out/share/icons/hicolor/$size/apps
        cp ${./hytale.png} $out/share/icons/hicolor/$size/apps/${pname}.png
      done

      mkdir -p $out/share/pixmaps
      cp ${./hytale.png} $out/share/pixmaps/${pname}.png
    '';

    meta = with lib; {
      description =
        "Official Hytale game launcher (v${version}) with Vulkan optimizations"
        + lib.optionalString enableGamemode " and GameMode support";
      homepage = "https://hytale.com";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = pname;
      maintainers = [];
    };
  }
