{
  flake.modules.nixos.python =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        jetbrains.pycharm
        (python3.withPackages (
          p: with p; [
            numpy
            matplotlib
            mathutils
            pyautogui
            pyside6
            pygame
            scipy
            ruff
          ]
        ))
        pyright # LSP adicional para Python
      ];
    };
}
