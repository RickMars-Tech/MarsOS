#= Esta configuracion me parece menos conflictiva que el Flake Oficial de Bongocat
{pkgs, ...}: let
  bongoFile = ./config/bongocat.conf;
in {
  systemd.user.services.wayland-bongocat = {
    Unit = {
      Description = "Wayland Bongo Cat Overlay";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Service = {
      Type = "exec";
      ExecStart = "${pkgs.wayland-bongocat}/bin/bongocat -c ${bongoFile} --watch-config";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
