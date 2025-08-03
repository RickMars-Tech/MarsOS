{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #= PC monitoring
    #s-tui # Monitoreo de CPU (frecuencia, temp, uso)
    #i7z # Detalles específicos de Intel Sandy Bridge
    stacer # Linux System Optimizer and Monitoring.
    cpu-x
    s-tui
    clinfo
    glxinfo
    hardinfo2
    hwinfo
    lm_sensors
    msr-tools # Para leer/escribir MSR
    # intel-undervolt # Para aplicar undervolting
    # gaming monitoring
    goverlay
    mangohud
    #vkbasalt
  ];
}
