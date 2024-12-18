# NIXOS MARS

#  IMPORTANT
-I recommend editing the configuration files to your liking since they contain a specific configuration for my hardware so you can improve your customization and also avoid errors.

# How to Use
```bash
git clone https://github.com/RickMars-Tech/NixOS-Mars.git
cd NixOS-Mars

sudo nixos-rebuild boot --upgrade --experimental-features 'nix-command flakes' --flake .
```

# Experimental
```bash

nix-shell -p git --command "nix run github:RicKMars-Tech/NixOS-Mars --extra-experimental-features nix-command --extra-experimental-features flakes"

```
