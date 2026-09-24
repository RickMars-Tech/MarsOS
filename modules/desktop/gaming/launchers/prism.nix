{
  flake.modules.nixos.prism =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          (prismlauncher.override {
            additionalLibs = [
              bzip2
              openssl
              nss
              nspr
            ];
            additionalPrograms = with pkgs; [
              ffmpeg
              glfw
            ];
            jdks = [
              temurin-jre-bin
              temurin-jre-bin-25
              temurin-jre-bin-17
              temurin-jre-bin-8
            ];
            gamemodeSupport = true;
          })
        ];
        sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";
      };

      # Java
      programs.java = {
        enable = true;
        package = pkgs.temurin-jre-bin;
        binfmt = true;
      };
    };
}
