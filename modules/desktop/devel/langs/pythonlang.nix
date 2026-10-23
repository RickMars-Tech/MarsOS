{
  flake.modules.nixos.python =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (python3.withPackages (
          p: with p; [
            mathutils
            matplotlib
            numba
            numpy
            pillow
            pyautogui
            pyside6
            pygame
            ruff
            scipy
          ]
        ))
      ];
    };
}
