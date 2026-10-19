{
  flake.modules.nixos.dbus = { pkgs, ... }: {
    # The patch is not mine
    # https://github.com/NixOS/nixpkgs/issues/303078#issuecomment-4698342707
    services.dbus = {
      brokerPackage = pkgs.dbus-broker.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./dbus-broker-logging.patch
        ];
      });

    };
  };
}
