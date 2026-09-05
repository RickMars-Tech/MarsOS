{ self, ... }:
{
  flake.modules.nixos = {
    shell = {
      imports = with self.modules.nixos; [
        alss
        prompt
        shellTools
      ];
    };
  };
}
