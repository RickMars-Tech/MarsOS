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

 -  **7 GB RAM + ~9.3 GB swap** (zram zstd 75% → 5.3 G sin comprimir, prio 100 +
    **partición** swap `p2` de 4 GB prio 10 en `hosts/rift/disko.nix`; disko
    genera `swapDevices` sola).
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

### Swap: partición `p2` de 4 GB (no swapfile)

El swap de disco es una **partición** de 4 GB (prio 10) declarada en
`hosts/rift/disko.nix`; lo principal lo cubre zram con zstd (prio 100, se usa
primero). Disko genera la entrada de `swapDevices` sola (`by-partlabel/swap`,
`discardPolicy = "once"`): no declararla a mano en `drives.nix` o saldría
duplicada.

Motivo: en BTRFS un swapfile activo hace que `scrub`/`balance` se salten sus
block groups y que no se pueda snapshotear el subvolumen que lo contiene.

Dato del disco de `rift`: entre `p1` (ESP, acaba en 1.001 GiB) y `p3` (root,
empieza en 5.001 GiB) había un hueco de exactamente **4.0 GiB**, resto de una
partición swap anterior. Por eso la partición se pudo recrear sin encoger nada:

```bash
sudo sgdisk --new=2:0:+4G --typecode=2:8200 --change-name=2:swap /dev/nvme0n1
sudo partprobe /dev/nvme0n1          # si no aparece p2, reiniciar
sudo mkswap -L swap /dev/disk/by-partlabel/swap
```

El montaje es por `by-partlabel`, así que el número de partición da igual.
Ojo: crear la partición **antes** de `nixos-rebuild switch` con la config nueva;
si no, el fstab apunta a un dispositivo inexistente (sin swap y espera al
arrancar). Tras el switch, borrar el `/swapfile` viejo para recuperar 4 GB:
`sudo swapoff /swapfile && sudo rm /swapfile`.

La máquina soporta hibernación (`disk` en `/sys/power/state`), pero **no está
configurada** y 4 GB no bastan para 7 GB de RAM: requeriría ampliar la swap y
añadir `boot.resumeDevice` + `resume=UUID=...`.

### `/home` es un subvolumen BTRFS, no una partición aparte

El layout es **ESP 1G | swap 4G | root (resto) BTRFS** con los subvolúmenes
`/root`, `/home`, `/nix` y `/var/log`. Tener `/home` como subvolumen da la
separación lógica (snapshots independientes) **sin** perder el espacio
compartido; particionarlo lo fijaría y añadiría un slot de GPT sin ganancia real.

Limitación conocida: BTRFS **no soporta `casefold`** (btrfs-todo#44; lo tienen
ext4, f2fs y bcachefs desde 6.15), así que Wine/Proton cae al emulador de
mayúsculas en userspace en vez de usar `chattr +F`. Se probó una partición
`/home` en ext4 para tener casefold nativo y se descartó: no compensa perder el
espacio compartido. Para juegos en BTRFS sí merece la pena quitar CoW en la
carpeta de la librería: `chattr +C ~/Games/SteamLibrary` (carpeta vacía; solo
aplica a archivos nuevos).




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
