# Es imposible hacer el cambio de GPU en nouveau por medio de FeralGamemode usando GAMEMODERUNEXEC,
# unicamente con DRI_PRIME debido a que es unicamente una variable de entorno y esta Variable es para especificar un comando,
# por lo tanto es necesario crear un equivalente al script "nvidia-offload" creado por la opcion "hardware.nvidia.prime.offload.enableOffloadCmd"
{pkgs}:
pkgs.writeShellScriptBin "nouveau-prime-run" ''
  export DRI_PRIME=1
  # Sobreescribir el VK_ICD_FILENAMES global — NVK primero para offload
  export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/nouveau_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nouveau_icd.i686.json"
  export __GLX_VENDOR_LIBRARY_NAME="mesa"
  export GALLIUM_DRIVER="nouveau"
  export MESA_LOADER_DRIVER_OVERRIDE="zink"
  export DXVK_FILTER_DEVICE_NAME="NVIDIA GeForce RTX 4050"
  export MESA_SHADER_CACHE_MAX_SIZE="10G"
  exec "$@"''
