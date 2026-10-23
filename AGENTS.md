MarsOS — Reglas del proyecto
============================

Flake NixOS (hosts en ./hosts , usuario y sistema (ejemplo: `x86_64-linux`) en
./hosts/rift/default.nix, con enfoque **dendritic**: `flake.nix` solo ensambla
`flake-parts` + `import-tree` sobre `./modules` y `./hosts`.


Estructura
----------

~~~~
flake.nix                  # flake-parts + import-tree [ ./modules ./hosts ]
modules/flake-parts.nix    # systems, formatter (nixfmt-rs), option flake.wrapperModules
modules/<area>/<tema>/     # UN archivo .nix = un módulo auto-importado
hosts/rift/default.nix     # nixosConfigurations.rift + lista de imports del host
hosts/rift/disko.nix       # flake.diskoConfigurations.rift
pkgs/default.nix           # overlay: final.callPackage ./<pkg> { }
~~~~

No hay `home-manager`. Todo se configura como módulos NixOS.


Convención dendritic (patrón de todos los módulos)
--------------------------------------------------

Cada archivo `.nix` bajo `modules/` es importado automáticamente por
`import-tree` y debe **exportar** en vez de importarse a mano:

~~~~ nix
# módulo hoja
{
  flake.modules.nixos.nombreModulo = { pkgs, ... }: { ... };
}

# agregador (solo junta imports)
{ self, ... }:
{
  flake.modules.nixos.system = { ... }: {
    imports = with self.modules.nixos; [ core hardware network nix ];
  };
}

# paquete envuelto (helix, ghostty, opencode): módulo + perSystem en el mismo archivo
{
  flake.modules.nixos.ghostty = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myGhostty ];
  };
  perSystem = { pkgs, ... }: {
    packages.myGhostty = inputs.wrapper-modules.wrappers.ghostty.wrap { inherit pkgs; /* ... */ };
  };
}

# Archivos del usuario vía hjem
{
  flake.modules.nixos.archivos-usuario = {username,...}:{
    # Steam Download Fixes
    hjem.users.${username}.xdg.data.files."Steam/steam_dev.cfg" = {
      text = ''
        @eHTTP2PlatformLinux 0
        @nClientDownloadEnableHTTP2PlatformLinux 0
        @fDownloadRateImprovementToAddAnotherConnection 1.0
        @unShaderBackgroundProcessingThreads 6
      '';
    };
  };
}
~~~~

Para activar/desactivar un módulo se edita la lista `imports` de
`hosts/rift/default.nix` (`flake.modules.nixos.riftModules`), **no** se agrega
un `import = ./ruta;` en el módulo.

También existen `flake.wrapperModules.*` (configs para `nix-wrapper-modules`,
p. ej. `hxCore`, `niriBinds`) y `flake.diskoConfigurations.*`.


Comandos de verificación (ejecutar en este orden tras editar `.nix`)
--------------------------------------------------------------------

1.  `git add <archivos-nuevos>` — **`import-tree` solo evalúa archivos
    trackeados por git**; un `.nix` nuevo sin `git add` es invisible y el eval
    “pasa” sin incluirlo.
2.  `nix eval .#nixosConfigurations.rift.config.system.build.toplevel.drvPath`
    — eval completo del sistema (~30 s). Es la verificación real.
3.  `nix fmt -- --check .` / `nix fmt .` — nixfmt-rs.
4.  `statix check .` y `deadnix -f .` — lint.

`nix flake show --all-systems` **falla** (evalúa `x86_64-darwin` y explota en
`formatter`); usar `nix eval` dirigido, no `flake check/show`.


Rebuild
-------

La sesión NO tiene `sudo`. El rebuild lo ejecuta el usuario:

 -  `nh os switch . #rift` (alias de shell: `snowswitch`), `snowboot`,
    `snowtest`
 -  o `sudo nixos-rebuild switch --flake .#rift`

Nunca pidas al usuario un rebuild como “test” rutinario; con el eval basta
salvo que pida probar algo en vivo.


Máquina (importante para diagnóstico)
-------------------------------------

 -  **7 GB RAM + ~9.3 GB swap** (zram zstd 75% prio 100 + **partición** swap 4
    GB prio 10, definida en `hosts/rift/disko.nix`). No hay swapfile: en BTRFS
    un swapfile degrada `scrub`/`balance` y aquí `autoScrub` está activo.
    disko genera la entrada de `swapDevices` sola (no declararla a mano en
    `drives.nix`).
 -  **earlyoom activo** con umbrales 8%/8%: mata procesos si la RAM se agota.
    `nix.settings.cores = 4` y `max-jobs = 4` limitan builds pesados (con
    `auto`/`0` los builds de Rust ahogaban la máquina y mataban COSMIC).
 -  Logs: `journalctl -b`, `journalctl -u earlyoom`, `coredumpctl list`.
 -  `journalctl -k` no siempre tiene los mensajes OOM (earlyoom mata antes que
    el OOM killer del kernel); buscar `grep earlyoom`.


Gotchas / fixes conocidos
-------------------------

### NVIDIA: binarios userspace rotos (nvidia-smi, nvidia-powerd) — SEGV

Síntoma: al hacer switch, `nvidia-powerd.service` falla con `code=dumped,
signal=SEGV` y `nh` aborta la activación. En el journal aparecen segfaults
periódicos de `nvidia-smi` (cada ~30 s) y `nvidia-powerd`, siempre en el mismo
sitio: `segfault at 0x401568 ... in ld-linux-x86-64.so.2` con `si_code=SEGV_ACCERR`.

Causa: en `pkgs/os-specific/linux/nvidia-x11/builder.sh` de nixpkgs los binarios
se parchean con `patchelf --set-interpreter ... --set-rpath ...`. Ese patchelf
reordena los program headers y deja la sección `.dynamic` dentro de un segmento
`LOAD R` (solo lectura) en vez de `RW`. Al arrancar, el linker escribe en
`.dynamic` y el kernel lo mata con SEGV. Afecta a **todas** las ramas del driver
(615 y 595 por igual), no es cosa de una versión.

Comprobar (Python sobre los program headers): `.dynamic` debe caer en un `LOAD
RW`; si cae en `LOAD R`, está roto. También es determinista: el binario crashea
si stdout **no** es un pipe (a `/dev/null`, a archivo o a tty da 139), lo que
engañó al principio al probar con `| head`.

Fix en `modules/system/hardware/gpus/nvidiaPro.nix`: wrapper `nvidiaPatched` que
hace `overrideAttrs` del paquete nvidia y, en `postInstall`, re-parchea los
binarios desde `$bin/origBin/` (la copia sin tocar que deja el builder) con
`patchelf --no-sort --set-interpreter ... --set-rpath ...`. El `--no-sort`
preserva los headers y deja `.dynamic` en `RW`.

Si un día nixpkgs arregla el `builder.sh` upstream, se puede eliminar el wrapper.
Comprobar tras rebuild: `nvidia-smi` debe listar la GPU (RTX 4050) sin SEGV.

### Avisos ACPI benignos del firmware ASUS

`NVRM: ... failed to get target temp / platform power mode from SBIOS` en el
journal: el firmware ASUS no expone esos datos por ACPI. No es un fallo de la
config; solo limita la capacidad de Dynamic Boost de `nvidia-powerd`.

### Reparto de perfiles de energía (COSMIC + asusd)

System76-Power (lo habilita con `mkDefault` el módulo COSMIC de nixpkgs cuando
`power-profiles-daemon` y `tuned` están apagados) gestiona los perfiles:
escribe `/sys/firmware/acpi/platform_profile` y EPP. asusd debe quedarse **sin**
gestión de perfiles (`change_platform_profile_on_ac/battery` y
`platform_profile_linked_epp` en `false` vía `services.asusd.asusdConfig.text`)
para no competir por la misma interfaz.

Ojo con el RON de asusd: el struct `Config` no tiene `serde(default)` en casi
ningún campo, así que un `asusdConfig.text` **parcial** hace que asusd lo
descarte y vuelva a los defaults (reactivando la gestión de perfiles). Hay que
escribir el archivo completo. Además, al gestionarlo Nix pasa a ser un symlink
de solo lectura al store y los cambios en runtime (`asusctl -c NN`) no persisten.

### `sysrq_always_enabled` y `lsm=`: dos trampas del cmdline

 -  **`sysrq_always_enabled=0` hace lo contrario de lo que parece**: el
    parámetro usa `__setup()` y el handler **ignora el valor**, forzando SysRq
    siempre activo. No declararlo; para desactivarlo de verdad se usa el sysctl
    `kernel.sysrq = 0` (`boot.kernel.sysctl`). No existe `boot.kernel.sysrq`.
 -  **`lsm=` a mano choca con nixpkgs**: al habilitar AppArmor, nixpkgs genera
    su propio `lsm=` y el kernel usa el **último** de la cmdline, anulando en
    silencio el endurecimiento manual (tomoyo/selinux/integrity no se activan).
    No declarar `lsm=` en `kernelParams`; usar `security.lsm` (y no meter
    `lockdown`/`integrity`, que no son LSMs apilables por `lsm=`).

### WirePlumber: las reglas matchean por `device.name`/`node.name` reales

Las direcciones PCI en las reglas deben coincidir con las reales de la máquina
(`pw-cli list-objects | grep alsa_card`). En `rift`: `01_00.1` = HDMI NVIDIA
(se deshabilita), `35_00.1` = HDMI AMD, `35_00.6` = ALC256 analógico (salida
"Master"/"System"). Reglas con PCI inexistentes no hacen nada y no dan error.

### ClamAV y MySQL no deben arrancar en el boot

`services.clamav.daemon` mete `clamav-daemon.service` en `multi-user.target` y
`freshclam` tiene `Requires=network-online.target`: entre red + descarga de la
base de datos, el arranque se alargaba ~11 s (y clamd dejaba ~1 GB de RAM
residente). Solución en `modules/system/core/security/default.nix`: forzar
`wantedBy/after/wants/requires` del daemon y de freshclam a `[]`. Con eso clamd
queda **on-demand** vía `clamav-daemon.socket` (ClamUI lo arranca al usarlo) y
freshclam solo corre por su timer.

MySQL (`services.mysql`) no tiene socket activation en NixOS; en `db.nix` se
deja instalado pero con `systemd.services.mysql.wantedBy = lib.mkForce [ ]`
(consume ~479 MB y no se usa a diario). Arrancarlo a mano: `systemctl start mysql`.

### Plymouth: poco tiempo visible / pantalla negra

El síntoma "aparece un momento y luego negro" tenía dos causas:

 1.  **`clamav-daemon` bloqueaba `multi-user.target`**: Plymouth terminaba a
     los ~5 s pero el greeter no arrancaba hasta ~16 s → ~10 s de negro. Ver
     arriba.
 2.  **`amdgpu` no estaba en el initrd**: Plymouth corría sobre el framebuffer
     básico y al cargar KMS había un cambio de modo (flicker). Se arregla con
     `hardware.amdgpu.initrd.enable = true` (añade `amdgpu` a
     `boot.initrd.kernelModules`).

Diagnóstico: `systemd-analyze` / `systemd-analyze blame` / `critical-chain`, y
`journalctl -b | grep -i plymouth`.

### ClamUI: el wheel no trae .desktop ni iconos

El wheel de ClamUI solo instala `bin/clamui`; no incluye `.desktop`, icono ni
metainfo (eso lo genera meson en el repo, que aquí no se ejecuta). En
`pkgs/clamui/default.nix` se añaden a mano: `makeDesktopItem` (AppID
`io.github.linx_systems.ClamUI`), iconos svg/png en `share/icons/hicolor/...` y
el metainfo en `share/metainfo/`. Los `fetchurl` apuntan al tag `v${version}`
del repo de GitHub (hashes SRI; `nix-prefetch-url` da base32, hay que convertir
con `nix hash convert --to sri`).

### Swap: partición, nunca swapfile en BTRFS con autoScrub

En BTRFS un swapfile activo **degrada `scrub` y `balance`** (los block groups
con extents del swapfile se saltan) y no se puede snapshotear el subvolumen que
lo contiene. Con `services.btrfs.autoScrub` activo es lo peor posible. Por eso
el swap es una **partición** (4 GB, prio 10) declarada en
`hosts/rift/disko.nix`; lo principal lo cubre zram (prio 100 > 10).

Disko genera **solo** la entrada de `swapDevices` desde su `_config` (con
`device = /dev/disk/by-partlabel/swap` y `discardPolicy`): no declarar
`swapDevices` a mano en `drives.nix` o saldrá duplicado. Revisar el resultado:
`grep -iE 'swap|mkswap' $(nix build --no-link --print-out-paths
.#nixosConfigurations.rift.config.system.build.diskoScriptNoDeps)`.

Ojo: evaluar `config.swapDevices` aislado con este nixpkgs (26.11) da un falso
positivo `swapDevices.*.label was accessed but has no value defined` (lo dispara
`stage-1.nix`); ya pasaba con el swapfile. El `drvPath` del toplevel evalúa sin
problema, así que no bloquea la instalación.

La máquina soporta hibernación (`disk` en `/sys/power/state`), pero **no está
configurada**: sin `boot.resumeDevice`/`resume=` no se reanuda. Si algún día se
quiere, con partición swap basta añadir `resume=UUID=...`; con swapfile en BTRFS
habría que calcular `resume_offset` (`btrfs inspect-internal map-swapfile`).

### `/home`: partición ext4 aparte (layout fijo híbrido)

`hosts/rift/disko.nix` tiene un layout **fijo**: ESP 1G | swap 4G | root 120G
**BTRFS** | `/home` (resto) **ext4 + `casefold`**. No hay selectores de FS.

El motivo de la mezcla: BTRFS **no soporta `casefold`** (sigue abierto en
`btrfs-todo#44`; lo tienen ext4, f2fs y bcachefs desde 6.15), y `casefold` es lo
que evita que Wine/Proton caiga al emulador en userspace al abrir su `drive_c`.
Así root se queda con compresión zstd, subvolúmenes y snapshots, y los juegos
viven en ext4. En btrfs **no** existe el subvolumen `/home` (chocaría con el
montaje de la partición).

Consecuencia: el espacio deja de compartirse; si una partición se llena no puede
usar el hueco de la otra. Con los datos actuales (`/nix/store` ~56G, sistema
~5G, `/home` ~160G) el reparto 120G + resto deja margen.

Reinstalar conservando `/home` **no sale gratis**: el `--mode destroy,...` de
disko borra el GPT entero. Hay que poner `destroy = false` en el disk y borrar
el FS de root a mano (`wipefs -a /dev/nvme0n1p3`); `_format` de disko salta
particiones que ya tienen FS (`blkid | grep TYPE=`) y `_create` solo hace
`sgdisk --clear` si el disco no tiene tabla.

FSck: no hay que tocar nada. NixOS salta `btrfs` **siempre** y `ext4` salvo que
se active `boot.initrd.checkJournalingFS`, así que el `fsck.mode=skip` global de
`drives.nix` no cambia el comportamiento de un `/home` ext4.




Reglas de trabajo
-----------------

 -  **Responder en español.**
 -  **No hacer commit salvo petición explícita.**
 -  Preferir `Read`/`Edit`/`Grep`/`Glob` sobre `bash grep/sed/cat`.
 -  Tests mínimos: para tareas sencillas, mejor preguntar que ejecutar baterías
    de comprobaciones.
 -  Mantener el estilo: comentarios en español, nixfmt, sin comentarios obvios.
 -  `flake.lock` y `modules/` suelen tener cambios sin commitear; revisar
    `git status` antes de tocar nada.
