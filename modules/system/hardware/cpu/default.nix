{
  imports = [
    ./amd.nix
    ./intel.nix
  ];
  hardware.cpu.x86.msr.enable = true;
}
