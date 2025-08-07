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
        qmlls = {
          command = "qmlls";
          args = ["-E"];
        };
        ruff = {
          command = "ruff";
          args = ["check"];
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = ["nil"];
          formatter = {
            command = lib.getExe pkgs.alejandra;
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = ["rust-analyzer"];
          formatter = {
            command = "rustfmt"; #lib.getExe pkgs.rustfmt;
          };
        }
        {
          name = "python";
          scope = "source.python";
          file-types = ["py" "pyi" "py3" "pyw"];
          auto-format = true;
          language-servers = ["ruff"];
          formatter = {
            command = lib.getExe pkgs.ruff;
            args = ["-" "--quiet" "--line-length 100"];
          };
        }
        {
          name = "qml";
          auto-format = true;
          language-servers = ["qmlls"];
        }
        {
          name = "c";
          auto-format = true;
          language-servers = ["clangd"];
        }
        {
          name = "cpp";
          auto-format = true;
          language-servers = ["clangd"];
        }
        {
          name = "zig";
          auto-format = true;
          language-servers = ["zls"];
          formatter = {
            command = lib.getExe pkgs.zig;
          };
        }
        {
          name = "kdl";
          auto-format = true;
          language-servers = [];
          formatter = {
            command = lib.getExe pkgs.kdlfmt;
          };
        }
      ];
    };
  };
}
