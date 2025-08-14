{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #= PC monitoring
    stacer # Linux System Optimizer and Monitoring.
    cpu-x
    s-tui
    clinfo
    glxinfo
    hardinfo2
    hwinfo
    lm_sensors
  ];
}
