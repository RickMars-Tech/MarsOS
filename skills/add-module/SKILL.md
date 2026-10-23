---
name: add-module
description: Add or modify a NixOS module in MarsOS's dendritic flake (modules/, flake.modules.nixos, hosts/rift imports, import-tree git add). Use when creating, enabling, disabling, or restructuring any .nix module in this repo.
---

# Añadir / modificar un módulo en MarsOS

## Reglas de la estructura dendritica

- Cada archivo `.nix` bajo `modules/` es importado SOLO por `import-tree`.
  Nunca escribas `import = ./ruta;` a mano.
- Un archivo **exporta** módulos con `flake.modules.nixos.<nombre> = { ... }: { ... };`
- Varios módulos pueden vivir en el mismo archivo (p. ej. módulo + `perSystem`
  para paquetes envueltos).
- El agregador `modules/<area>/default.nix` (si existe) solo junta
  `imports = with self.modules.nixos; [ ... ];`.
- Activar/desactivar feature = editar la lista de `hosts/rift/default.nix`
  (`flake.modules.nixos.riftModules`), no tocar el archivo del módulo.

## Pasos para crear un módulo nuevo

1. Elegir ubicación: `modules/<área>/<tema>/<archivo>.nix`.
   Áreas: `system/{core,hardware,network,virtualization}`,
   `desktop/{browser,devel,gaming,media,session,terminal}`, `nix/`.
2. Escribirlo exportando `flake.modules.nixos.<nombre>`:

   ```nix
   { pkgs, ... }:
   {
     flake.modules.nixos.<nombre> = {
       environment.systemPackages = with pkgs; [ ... ];
     };
   }
   ```

   (Si el archivo necesita `self`/`inputs`, van en el lambda externo
   `{ self, inputs, ... }:` como en `modules/desktop/devel/helix/default.nix`.)

3. **`git add <archivo>` — obligatorio.** `import-tree` solo lee archivos
   trackeados por git; sin esto el eval "pasa" pero el módulo no existe.
4. Activarlo en `hosts/rift/default.nix` (lista `imports`) si es una feature
   nueva y no está ya activada por un agregador.
5. Verificar (ver skill `verify`): eval + fmt + statix/deadnix.

## Modificar existente

- Editar el archivo directamente; ya está en el eval.
- Si solo se quiere desactivar una feature en `rift`: comentar su entrada en
  `hosts/rift/default.nix`.

## Estilo

- Comentarios en español, nixfmt (`nix fmt .`), sin comentarios obvios.
- Opciones NixOS nativas; no inventar options propias salvo que haga falta.
