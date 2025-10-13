{pkgs, ...}: {
  programs.bat = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [bat-extras.batman];
}
