{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs;
      (steam-run.args.multiPkgs pkgs)
      ++ (heroic.args.multiPkgs pkgs)
      # ++ (lutris.args.multiPkgs pkgs)
      ++ [
        alsa-lib
        dbus
        glibc
        gst_all_1.gstreamer
        gst_all_1.gst-libav
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-vaapi
        gtk3
        icu
        libcap
        libxcrypt
        libGL
        libdrm
        libudev0-shim
        libva
        pkg-config
        libX11
        libXext
        udev
        vulkan-loader
        egl-wayland
        eglexternalplatform
        libGL
        vdpauinfo
        libvdpau-va-gl
        libva-vdpau-driver
        libva-utils
      ];
  };
}
