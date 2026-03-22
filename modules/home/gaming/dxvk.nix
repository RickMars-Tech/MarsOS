{
  # DXVK configuration
  environment.etc."dxvk.conf".text = ''
    # DXVK configuration for gaming optimization

    # Enable State Cache
    dxvk.enableStateCache = True

    # GPU selection (auto-detect)
    dxvk.gpuSelection = 0

    # Memory allocation
    dxvk.maxFrameLatency = 1
    dxvk.numCompilerThreads = 0

    # Shader compilation
    dxvk.useRawSsbo = True

    # D3D11 specific
    d3d11.constantBufferRangeCheck = False
    d3d11.relaxedBarriers = True
    d3d11.maxTessFactor = 64
  '';
}
