---
name: verify
description: Verification commands to run after editing any .nix file in MarsOS (nix eval toplevel, nix fmt, statix, deadnix, git add before eval). Use AFTER any change to the flake before reporting done.
---

# Verificar cambios en MarsOS

Ejecutar en este orden desde la raíz del repo:

```bash
# 0. Archivos .nix NUEVOS: import-tree exige que estén trackeados
git add <archivo.nuevo.nix>

# 1. Eval completo del sistema (la verificación real, ~30s)
nix eval .#nixosConfigurations.rift.config.system.build.toplevel.drvPath

# 2. Formato (nixfmt-rs)
nix fmt -- --check .   # solo chequear
nix fmt .              # corregir

# 3. Lint
statix check .
deadnix -f .
```

## Qué NO usar

- `nix flake check` / `nix flake show --all-systems` → fallan evaluando
  `x86_64-darwin` (crashea en `formatter`); no sirven como verificación.
- No pidas `nixos-rebuild`/`nh` de prueba para tareas sencillas; el eval basta.
  El usuario tiene los aliases `snowswitch`/`snowboot`/`snowtest` para eso.

## Señales de que algo falló

- Eval con error de opción desconocida → revisar sintaxis o imports del módulo.
- Eval "pasa" pero la feature no aparece → casi siempre es un archivo nuevo
  sin `git add`.
- `statix` warn L1 sobre `with` innecesario → estilo, corregir si tocas el archivo.

Solo commit si el usuario lo pide explícitamente.
