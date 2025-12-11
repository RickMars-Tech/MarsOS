{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
in {
  imports = [
    ./git.nix
    ./packages.nix
    ./vscode.nix
  ];
  options.mars.dev = {
    git = {
      enable = mkEnableOption "Enable Git" // {default = true;};
      username = mkOption {
        default = "";
        description = "Username";
      };
      email = mkOption {
        default = "";
        description = "Email";
      };
    };
    languages = {
      nix = mkEnableOption "Enable Nix & tools" // {default = true;}; #= We always need Nix
      cpp = mkEnableOption "Enable C++ & tools" // {default = false;};
      rust = mkEnableOption "Enable Rust & tools" // {default = false;};
      zig = mkEnableOption "Enable Zig & tools" // {default = false;};
      python = mkEnableOption "Enable Python & tools" // {default = false;};
      octave = mkEnableOption "Enable Octave & tools" // {default = false;};
    };
    ide = {
      arduino = mkEnableOption "Enable Arduino IDE" // {default = false;};
      vscode = mkEnableOption "Enable VsCode" // {default = false;};
    };
    flash = {
      flashprog = mkEnableOption "Enable Flashprog" // {default = false;};
    };
  };
}
