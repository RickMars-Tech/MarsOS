---
name: diagnose-system
description: Diagnose problems on the live MarsOS machine (rift): boot failures, crashes, OOM/earlyoom kills, COSMIC/greeter issues, nvidia, reading journalctl and coredumps. Use when something on the system is broken, crashing, slow, or after a bad rebuild.
---

Diagnóstico del sistema (rift)
==============================

Contexto de la máquina
----------------------

 -  8 GB RAM(Detectados 7, iGPU toma parte de ram fisica) + ~7.5 GB swap (zram
    zstd 75% prio 100, swapfile 4 GB prio 10).
 -  **earlyoom** (umbrales 8%/8%) mata procesos bajo presión; a menudo mata
    ANTES que el OOM killer del kernel, así que `journalctl -k` puede no
    mostrar nada.
 -  Sesión: COSMIC (`cosmic-session` + greetd/cosmic-greeter), driver nvidia
    propietario (`modules/system/hardware/gpus/nvidiaPro.nix`).
 -  La sesión NO tiene sudo: los comandos que lo requieren los corre el usuario.


Kit de comandos
---------------

~~~~ bash
journalctl -b -p err..emerg        # errores del arranque actual
journalctl -u earlyoom -b          # qué mató earlyoom y cuándo
journalctl -b | grep -i "segfault\|coredump\|panic"
coredumpctl list --since "2 hours ago"
coredumpctl info <PID o exe>       # causa raíz del crash (si corefile = none,
                                   # el proceso fue matado con señal sin core)
free -h && swapon --show           # presión RAM/swap
systemctl --failed                 # unidades rotas tras un switch
dmesg | grep -iE "oom|kill"        # OOM real del kernel
~~~~


Playbook según síntoma
----------------------

### “No arranca” / panic en initrd

 -  Casi siempre módulos del kernel o `kernelParams`. Comparar con la generación
    anterior: `nix profile history` / `ls -l /nix/var/nix/profiles/system-*`.
 -  Ver caso histórico: `module.sig_enforce=1` + `CONFIG_MODULE_SIG` (kernel
    7.2.11) rechazaba TODOS los módulos → root no montaba. Fix: quitar el param
    de `modules/system/core/kernel/common.nix`.
 -  Initrd para inspeccionar: `lsinitrd /nix/store/*-initrd-linux-*` (o extraer
    cpio + zstd manualmente).

### El escritorio crashea / se reinicia la sesión

 -  Primero: `journalctl -u earlyoom -b` → si dice
    `sending SIGTERM ... "cosmic-session"`, es OOM, no bug de COSMIC.
    Causa típica: build pesado en paralelo (`max-jobs`/`cores` mal puestos).
 -  Si hay `cosmic-applets`/`pop-launcher` con SIGABRT → `coredumpctl info`.

### Build de nix falla con `signal: 15, SIGTERM` en rustc

 -  earlyoom mató el build (RAM). No es error de código. Reducir paralelismo o
    cerrar aplicaciones; ver límites en `modules/nix/default.nix`.

### nvidia-smi crashea cada 30s (segfault en ld-linux)

 -  Ruido conocido de algún sondeo periódico; el daño real es solo el spam de
    coredumps. Si la GPU funciona, prioridad baja.


Después de diagnosticar
-----------------------

 -  Proponer el fix en el repo con la skill `add-module`/`add-package`
    correspondiente; no aplicar rebuild sin pedir.
 -  Si el fix es de config, evaluar con la skill `verify` y dejar que el usuario
    corra `snowswitch`.
