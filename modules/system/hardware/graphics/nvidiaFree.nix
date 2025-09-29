{
  # config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption; # optionalString;
  # nvidia = config.mars.graphics.nvidiaFree;
in {
  options.mars.graphics.nvidiaFree = {
    enable = mkEnableOption "Enable Free nVidia graphics Nouveau";
    vulkan = mkEnableOption "Vulkan Support via NVK" // {default = true;};
    opengl = mkEnableOption "OpenGL Support" // {default = true;};
    zink = mkEnableOption "Enable Zink OpenGL-on-Vulkan" // {default = false;};
    # galliumNine = mkEnableOption "Gallium Nine for D3D9 acceleration" // {default = false;};
  };

  # config = {
  #   # Additional Mesa configuration
  #   environment.etc."drirc".text = optionalString nvidia.galliumNine ''
  #     <driconf>
  #       <device>
  #         <application name="Default">
  #           <option name="allow_glsl_extension_directive_midshader" value="true" />
  #           ${optionalString nvidia.mesa.galliumNine ''
  #       <option name="allow_glsl_builtin_const_expression" value="true" />
  #     ''}
  #         </application>
  #       </device>
  #     </driconf>
  #   '';
  # };
}
