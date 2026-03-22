{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  programs.git = {
    enable = config.mars.dev.git.enable;
    lfs.enable = true;
    config = {
      user = {
        name = config.mars.dev.git.username;
        email = config.mars.dev.git.email;
      };

      core = {
        editor = "hx";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        autocrlf = "input";
      };

      init.defaultBranch = "main";

      # Better diffs and merges
      diff.algorithm = "patience";
      merge.conflictstyle = "diff3";

      # Push configuration
      push.default = "simple";
      push.autoSetupRemote = true;

      # Pull configuration
      pull.rebase = true;
    };
  };

  environment.systemPackages = with pkgs;
    mkIf config.mars.dev.git.enable [
      git-lfs # Large file support
      gh # GitHub CLI
      gitflow # Git Flow extensions
      tig # Text-based Git interface
      # lazygit # Terminal Git UI
      gitui # Another terminal Git UI
    ];
}
