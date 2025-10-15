# https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/bin/zink-run
{pkgs}:
pkgs.writeShellScriptBin "zink-run" ''
  export MESA_LOADER_DRIVER_OVERRIDE=zink
  export GALLIUM_DRIVER=zink
  export __GLX_VENDOR_LIBRARY_NAME=mesa
  export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
  exec "$@"
''
