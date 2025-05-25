{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    languages = {
      language-server = {
        rust-analyzer.config = {
          check = "clippy";
          proc-macro.enable = true;
        };
        gpt = {
          command = "helix-gpt";
          args = ["--handler" "codeium"];
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = ["nil" "gpt"];
          formatter = {
            command = lib.getExe pkgs.alejandra;
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = ["rust-analyzer" "gpt"];
          formatter = {
            command = "rustfmt"; #lib.getExe pkgs.rustfmt;
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["ruff" "gpt"];
          formatter = {
            command = lib.getExe pkgs.ruff;
            args = ["-" "--quiet" "--line-length 100"];
          };
        }
        {
          name = "c";
          auto-format = true;
          language-servers = ["clangd" "gpt"];
        }
        {
          name = "cpp";
          auto-format = true;
          language-servers = ["clangd" "gpt"];
        }
        {
          name = "zig";
          auto-format = true;
          language-servers = ["zls" "gpt"];
          formatter = {
            command = lib.getExe pkgs.zig;
          };
        }
        {
          name = "kdl";
          auto-format = true;
          language-servers = ["gpt"];
          formatter = {
            command = lib.getExe pkgs.kdlfmt;
          };
        }
      ];
    };
  };
}
