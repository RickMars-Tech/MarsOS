# Deprecated
{pkgs}:
pkgs.writeShellScript "audio-pm.sh" ''
  #!/usr/bin/env bash
  set -euo pipefail

  POWERSAVE_FILE="/run/udev/snd-hda-intel-powersave"
  PARAM_PATH="/sys/module/snd_hda_intel/parameters/power_save"

  # Función para obtener estado de batería
  get_battery_status() {
    for bat in /sys/class/power_supply/BAT*; do
      [[ -f "$bat/status" ]] && cat "$bat/status" && return
    done
    echo "Unknown"
  }

  case "$1" in
    init)
      mkdir -p "$(dirname "$POWERSAVE_FILE")"
      if [[ $(get_battery_status) != "Discharging" ]]; then
        [[ -f "$PARAM_PATH" ]] && cat "$PARAM_PATH" > "$POWERSAVE_FILE"
        echo 0 > "$PARAM_PATH"
      fi
      ;;
    on-ac)
      # En corriente: deshabilitar power saving (mejor audio)
      if [[ -f "$PARAM_PATH" ]] && [[ $(cat "$PARAM_PATH") != "0" ]]; then
        cat "$PARAM_PATH" > "$POWERSAVE_FILE"
        echo 0 > "$PARAM_PATH"
      fi
      ;;
    on-battery)
      # En batería: habilitar power saving
      [[ -f "$PARAM_PATH" ]] && echo "''${2:-10}" > "$PARAM_PATH"
      ;;
  esac
''
