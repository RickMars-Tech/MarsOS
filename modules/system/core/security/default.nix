{ self, ... }:
{
  flake.modules.nixos.security = {
    imports = [ self.modules.nixos.sudo-rs ];

    security.apparmor.enable = true;

    # SystemD hardening
    systemd = {
      coredump.settings.Coredump = {
        Storage = "none";
        ProcessSizeMax = 0;
      };
    };
  };
}
