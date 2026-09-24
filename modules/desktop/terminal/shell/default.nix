{ self, ... }:
{
  flake.modules.nixos = {
    shell = {
      imports = with self.modules.nixos; [
        aliases
        prompt
        shellTools
      ];
    };
  };
}
