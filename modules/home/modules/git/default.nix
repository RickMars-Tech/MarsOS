{pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "rickmars117@proton.me";
    userName = "RickMars-Tech";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;

      core = {
        editor = "hx";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        autocrlf = "input";
      };
    };
  };

  home.packages = with pkgs; [
    gitui
  ];
}
