{
  flake.modules.nixos.clamav = { pkgs, lib, ... }: {
    # ClamAV+ClamUI
    services.clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
    environment.systemPackages = with pkgs; [
      clamui
      lynis
    ];

    # ClamAV no debe retrasar el arranque:
    #  - clamav-daemon se activa on-demand por su socket (ClamUI lo arranca al
    #    usarlo); no hace falta en multi-user.target.
    #  - clamav-freshclam no debe bloquear el boot esperando la red; el timer
    #    ya lo ejecuta en segundo plano.
    systemd.services = {
      clamav-daemon = {
        wantedBy = lib.mkForce [ ];
        after = lib.mkForce [ ];
        wants = lib.mkForce [ ];
        requires = lib.mkForce [ "clamav-daemon.socket" ];
      };
      clamav-freshclam = {
        after = lib.mkForce [ ];
        requires = lib.mkForce [ ];
        wantedBy = lib.mkForce [ ];
      };
    };
  };
}
