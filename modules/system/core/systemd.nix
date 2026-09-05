{
  flake.modules.nixos.systemd =
    { lib, ... }:
    let
      inherit (lib) mkForce;
    in
    {
      systemd = {
        services = {
          NetworkManager-wait-online.wantedBy = mkForce [ ];
        };

        # Optimize SystemD
        settings.Manager = {
          DefaultTimeoutStartSec = "15s";
          DefaultTimeoutStopSec = "3s";
          DefaultLimitNOFILE = "2048:2097152";
        };
        user.settings.Manager.DefaultLimitNOFILE = "1024:1048576";
      };

      # JournalD
      services.journald.settings.Journal = {
        # Don't let journald eat up my SSD for no reason.
        # See https://news.ycombinator.com/item?id=49290215 and https://github.com/systemd/systemd/issues/40262
        # Logs won't survive restarts, but I hardly need that,
        # except maybe if I would want to investigate and report
        # an intermittent GPU driver crash I'm having.
        Storage = "volatile";

        SystemMaxUse = "50M";
      };

    };
}
