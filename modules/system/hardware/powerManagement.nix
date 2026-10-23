{
  flake.modules.nixos.powerManagement = { config, ... }: {
    services = {
      upower.enable = true;

      # Con COSMIC, System76-Power es el que gestiona los perfiles de energía
      # (expone la interfaz D-Bus net.hadess.PowerProfiles que consume
      # cosmic-settings). Por eso power-profiles-daemon solo queda activo si
      # asusd está apagado o si no se usa COSMIC (p. ej. sesión niri).
      power-profiles-daemon.enable =
        !config.services.asusd.enable || !config.services.desktopManager.cosmic.enable;
    };
  };
}
