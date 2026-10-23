{
  flake.modules.nixos.asus =
    {
      pkgs,
      ...
    }:
    {
      boot = {
        kernelParams = [
          "acpi_backlight="
          "acpi_osi=!"
          "acpi_osi=\"Windows 2020\""
        ];
      };

      services.asusd = {
        enable = true;
        package = pkgs.asusctl;
        # System76-Power (habilitado por el módulo COSMIC) gestiona los perfiles
        # de energía escribiendo /sys/firmware/acpi/platform_profile y el EPP de
        # la CPU. Si asusd también los escribiera, ambos demonios competirían
        # (condición de carrera), así que aquí se le quita a asusd el módulo de
        # perfiles y se le deja el resto (aura, fan curves, límite de carga).
        asusdConfig.text = ''
          (
              charge_control_end_threshold: 80,
              base_charge_control_end_threshold: 0,
              disable_nvidia_powerd_on_battery: true,
              ac_command: "",
              bat_command: "",
              platform_profile_linked_epp: false,
              platform_profile_on_battery: Quiet,
              change_platform_profile_on_battery: false,
              platform_profile_on_ac: Performance,
              change_platform_profile_on_ac: false,
              profile_quiet_epp: Power,
              profile_balanced_epp: BalancePower,
              profile_custom_epp: Performance,
              profile_performance_epp: Performance,
              ac_profile_tunings: {},
              dc_profile_tunings: {},
              armoury_settings: {},
          )
        '';
      };
    };
}
