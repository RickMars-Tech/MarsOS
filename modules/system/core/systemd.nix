{
  flake.modules.nixos.systemd =
    { lib, ... }:
    let
      inherit (lib) mkForce;
    in
    {
      systemd = {
        # systemd-oomd viene activado por defecto en NixOS. earlyoom ya cubre
        # esta función con umbrales pensados para 8GB, así que se desactiva
        # oomd para no tener dos OOM killers peleando por RAM/CPU.
        oomd.enable = false;

        # NixOS activa por defecto un ramfs de apagado: systemd pivota a
        # /run/initramfs antes de apagar, dejando el root real en /oldroot.
        # Ahí el parche de nixpkgs que hace que systemd ignore /nix/store no
        # aplica (compara la ruta exacta "/nix/store", no "/oldroot/nix/store"),
        # lo que provoca el flash "Failed to unmount /oldroot/nix/store:
        # Device or resource busy" al salir Plymouth. Al desactivarlo, el
        # apagado ocurre en una sola fase donde /nix y /nix/store sí se ignoran
        # correctamente. Ver NixOS/nixos#126 y microvm-nix/microvm.nix#464.
        shutdownRamfs.enable = false;

        services.NetworkManager-wait-online.wantedBy = mkForce [ ];

        # Optimize SystemD
        settings.Manager = {
          DefaultTimeoutStartSec = "15s";
          DefaultTimeoutStopSec = "10s";
          DefaultLimitNOFILE = "2048:2097152";
        };
        user.settings.Manager.DefaultLimitNOFILE = "1024:1048576";
      };

      # JournalD
      services.journald.settings.Journal = {
        # Don't let journald eat up my SSD for no reason.
        # See https://news.ycombinator.com/item?id=49290215 and https://github.com/systemd/systemd/issues/40262
        Storage = "volatile";
        SystemMaxUse = "50M";
      };
    };
}
