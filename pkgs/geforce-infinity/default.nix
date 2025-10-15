# Why prefer build a NixPackage from Appimage over source???
# It's easy, im very stupid to know how to build an Electron App with yarn or npm
# Enjoy :3
{
  appimageTools,
  electron,
  fetchurl,
  lib,
  makeWrapper,
  ...
}: let
  pname = "geforce-infinity";
  version = "1.1.3";
  src = fetchurl {
    url = "https://github.com/AstralVixen/GeForce-Infinity/releases/download/${version}/GeForceInfinity-linux-${version}-x86_64.AppImage";
    sha256 = "sha256-C2bHMOWfYVJ1vpQlbq0KWqQRqXkT19+W+q5No9G4l6Q=";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    nativeBuildInputs = [makeWrapper];

    extraInstallCommands = ''
      # Instalar archivos de desktop e iconos
      install -Dm644 ${appimageContents}/geforce-infinity.desktop -t $out/share/applications
      install -Dm644 ${appimageContents}/geforce-infinity.png \
      $out/share/icons/hicolor/500x500/apps/geforce-infinity.png

      # Crear icono en otras resoluciones para mejor compatibilidad
      mkdir -p $out/share/icons/hicolor/{48x48,64x64,128x128,256x256}/apps
      for size in 48 64 128 256; do
      install -Dm644 ${appimageContents}/geforce-infinity.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/geforce-infinity.png
      done

      # Alternativa: Reescribir completamente el archivo .desktop para evitar problemas
      cat > $out/share/applications/geforce-infinity.desktop << EOF
      [Desktop Entry]
      Name=GeForce Infinity
      Comment=A Next-Gen Application designed to Enhance The GeForce NOW Experience
      Exec=${pname}
      Icon=geforce-infinity
      Type=Application
      Categories=Game;Network;
      StartupNotify=true
      StartupWMClass=GeForce Infinity
      Terminal=false
      MimeType=
      Keywords=geforce;nvidia;gaming;streaming;
      EOF

      # Añadir campos faltantes al .desktop si no existen
      if ! grep -q "StartupNotify" $out/share/applications/geforce-infinity.desktop; then
        echo "StartupNotify=true" >> $out/share/applications/geforce-infinity.desktop
      fi
      if ! grep -q "StartupWMClass" $out/share/applications/geforce-infinity.desktop; then
        echo "StartupWMClass=GeForce Infinity" >> $out/share/applications/geforce-infinity.desktop
      fi
      if ! grep -q "Terminal" $out/share/applications/geforce-infinity.desktop; then
        echo "Terminal=false" >> $out/share/applications/geforce-infinity.desktop
      fi

      # Wrapper mejorado con variables de entorno y flags
      wrapProgram $out/bin/${pname} \
      --set ELECTRON_IS_DEV 0 \
      --set ELECTRON_ENABLE_LOGGING 1 \
      --set ELECTRON_FORCE_IS_PACKAGED true \
      --set XDG_DATA_DIRS "$XDG_DATA_DIRS:$out/share" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags "--no-sandbox" \
      --add-flags "--disable-gpu-sandbox" \
      --add-flags "--disable-dev-shm-usage" \
      --add-flags "--disable-software-rasterizer" \
      --add-flags "--enable-accelerated-2d-canvas" \
      --add-flags "--enable-zero-copy"

      # Crear script de debug opcional
      cat > $out/bin/${pname}-debug << 'EOF'
      #!/usr/bin/env bash
      echo "Debugging GeForce Infinity launch..."
      echo "Display: $DISPLAY"
      echo "Wayland: $WAYLAND_DISPLAY"
      echo "XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
      echo "Starting application with debug output..."
      exec "$out/bin/${pname}" "$@" --verbose --enable-logging
      EOF
      chmod +x $out/bin/${pname}-debug
    '';

    meta = {
      description = "A Next-Gen Application designed to Enhance The GeForce NOW Experience";
      longDescription = ''
        GeForce Infinity is an Electron-based application that enhances
        the GeForce NOW gaming experience with additional features and
        optimizations.
      '';
      homepage = "https://github.com/AstralVixen/GeForce-Infinity";
      license = lib.licenses.mit;
      platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
      maintainers = ["RickMars-Tech"];
      mainProgram = "geforce-infinity";
      broken = false;
      hydraPlatforms = lib.platforms.linux;
    };
  }
