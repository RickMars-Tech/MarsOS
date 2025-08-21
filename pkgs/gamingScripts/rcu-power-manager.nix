{pkgs}:
pkgs.writeShellScriptBin "rcu-power-manager" ''
  # Detectar si AC está conectado
  ac_connected() {
      # Buscar adaptador AC
      for ac in /sys/class/power_supply/{AC,ADP,ACAD}*; do
          [[ -f "$ac/online" ]] && [[ "$(cat "$ac/online" 2>/dev/null)" == "1" ]] && return 0
      done

      # Buscar por type=Mains
      for supply in /sys/class/power_supply/*; do
          [[ -f "$supply/type" ]] && [[ "$(cat "$supply/type")" == "Mains" ]] && \
          [[ "$(cat "$supply/online" 2>/dev/null)" == "1" ]] && return 0
      done

      return 1
  }

  # Ajustar RCU según estado de alimentación
  if ac_connected; then
      echo 0 > /sys/module/rcutree/parameters/enable_rcu_lazy 2>/dev/null || true
  else
      echo 1 > /sys/module/rcutree/parameters/enable_rcu_lazy 2>/dev/null || true
  fi
''
