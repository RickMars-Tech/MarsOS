---
name: add-package
description: Add a custom package to MarsOS (pkgs/<name>/default.nix, overlay in pkgs/default.nix, exposure via environment.systemPackages or self.packages wrapper). Use when packaging a new app, updating hashes, or fixing a broken build in pkgs/.
---

# Añadir un paquete a MarsOS

## Mecanismo

`modules/nix/overlays.nix` monta `import ../../pkgs` como overlay:
`pkgs/default.nix` es `final: _: { ... }` con `callPackage` de cada paquete.

## Pasos

1. Crear `pkgs/<nombre>/default.nix` (estilo `pkgs/postilla/default.nix`
   para buildRustPackage, o `pkgs/hytale/` si necesita `source.nix` + `update.sh`).
2. Registrar en `pkgs/default.nix`:
   `mi-paquete = final.callPackage ./mi-paquete { };`
3. Exponerlo al sistema (elegir UNO):
   - Directo desde un módulo: `environment.systemPackages = [ pkgs.mi-paquete ];`
   - Vía flake output + módulo (estilo helix/ghostty/opencode): declarar
     `perSystem = { ... }: { packages.myX = ...; }` en el mismo archivo del
     módulo y consumir con
     `self.packages.${pkgs.stdenv.hostPlatform.system}.myX`.
4. `git add` si hay archivos nuevos, luego verificar con la skill `verify`
   (además se puede probar el paquete suelto:
   `nix build .#nixosConfigurations.rift.pkgs.<nombre>` o
   `nix eval .#nixosConfigurations.rift.pkgs.<nombre>.name`).

## Gotchas

- Build con red: el sandbox de nix no tiene red; usar `fetchurl`/`fetchFromGitHub`
  con hashes fijos, o FOD (`outputHash`).
- `just`-based (postilla): revisar que los tools de build estén en
  `nativeBuildInputs` (`pkg-config`, `just`, `cmake`...) y libs en `buildInputs`
  (`fontconfig`, `openssl`...). El error típico es `*.pc not found` o
  `just: command not found`.
- Compilación pesada (Rust/C++): la máquina tiene 7 GB RAM y `cores = 4` /
  `max-jobs = 4`; no subir el paralelismo, earlyoom mata builds que se pasen.
- `allowUnfree = true` ya está global (`modules/nix/default.nix`).
