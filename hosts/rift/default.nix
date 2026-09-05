{
  inputs,
  self,
  ...
}:
let
  # Common variables values used arround the hole config
  commonArgs = {
    username = "rick";
    fullname = "Rick";
    system = "x86_64-linux";
    timeZone = "America/Chihuahua";
    locale = "es_MX.UTF-8";
  };
in
{
  # Host config
  flake.nixosConfigurations.rift = inputs.nixpkgs.lib.nixosSystem {
    inherit (commonArgs) system;
    specialArgs = commonArgs // {
      inherit inputs self;
    };
    modules = [
      self.modules.nixos.riftModules
      self.diskoConfigurations.rift
      inputs.disko.nixosModules.disko
    ];
  };

  # Modules used by the Host
  flake.modules.nixos.riftModules = {
    imports = with self.modules.nixos; [
      # Full system core settings
      system

      # Asusctl
      asus

      # AMD CPU & GPU
      amdcpu
      amdgpu

      # Nvidia Privative Driver with Prime Config
      nvidia-pro
      nvidia-pro-prime

      # Desktop Base & Gaming
      desktop
      fish-shell # comment if you prefer bash
      # bash-shell # uncomment if you prefer bash
      gaming
      devel

      # Winboat & Virtualization
      winboat
      docker # Needed for Winboat
      virtualization

      # Programing Tools for:
      python

      # Browsers
      firefox

    ];

    # Host name & stateVersion
    networking.hostName = "rift";
    system.stateVersion = "26.05";
  };
}
