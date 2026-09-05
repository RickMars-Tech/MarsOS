{ self, ... }:
{
  flake.modules.nixos.security = {
    imports = [ self.modules.nixos.sudo-rs ];
    security = {
    };
    # SystemD hardening
    systemd = {
      coredump.settings.Coredump = {
        Storage = "none";
        ProcessSizeMax = 0;
      };
    };
  };
}
