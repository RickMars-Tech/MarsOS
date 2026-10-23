{ self, ... }:
{
  flake.modules.nixos.security = {
    imports = with self.modules.nixos; [
      clamav
      sudo-rs
    ];

    security.apparmor.enable = true;

    # SystemD hardening
    systemd.coredump.settings.Coredump = {
      Storage = "none";
      ProcessSizeMax = 0;
    };
  };
}
