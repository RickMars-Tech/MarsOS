{pkgs, ...}: {
  programs.git = {
    enable = true;
    # package = pkgs.git.override {withLibsecret = true;};
    lfs.enable = true;
    userEmail = "rickmars117@proton.me";
    userName = "RickMars-Tech";
    # extraConfig = {
    #   credential.helper = "libsecret";
    # };
  };

  home.packages = with pkgs; [
    gitui
  ];
}
