{pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "rickmars117@proton.me";
    userName = "RickMars-Tech";
  };

  home.packages = with pkgs; [
    gitui
  ];
}
