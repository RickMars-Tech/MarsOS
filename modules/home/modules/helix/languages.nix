{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    languages = {
      language-server = {
        rust-analyzer.config = {
          check = {
            command = "clippy";
            features = "all";
          };
          cargo = {
            features = "all";
            loadOutDirsFromCheck = true;
          };
          procMacro = {
            enable = true;
            ignored = {
              leptos_macro = ["server"];
            };
          };
          diagnostics = {
            enable = true;
            experimental = {
              enable = true;
            };
          };
        };

        pyright = {
          command = "pyright-langserver";
          args = ["--stdio"];
          config = {
            reportMissingImports = true;
            reportMissingTypeStubs = false;
            python = {
              pythonPath = "python3";
              venvPath = ".venv";
            };
          };
        };

        ruff = {
          command = "ruff";
          args = ["server" "--preview"];
        };

        typescript-language-server = {
          command = "typescript-language-server";
          args = ["--stdio"];
          config = {
            preferences = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
            };
          };
        };

        nil = {
          command = "nil";
          config = {
            formatting = {
              command = ["alejandra"];
            };
          };
        };

        clangd = {
          command = "clangd";
          args = [
            "--background-index"
            "--clang-tidy"
            "--header-insertion=iwyu"
            "--completion-style=detailed"
            "--function-arg-placeholders"
            "--fallback-style=llvm"
          ];
        };

        taplo = {
          command = "taplo";
          args = ["lsp" "stdio"];
        };

        yaml-language-server = {
          command = "yaml-language-server";
          args = ["--stdio"];
        };

        bash-language-server = {
          command = "bash-language-server";
          args = ["start"];
        };

        marksman = {
          command = "marksman";
          args = ["server"];
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
            command = lib.getExe pkgs.rustfmt;
            args = ["--edition" "2021"];
          };
          # debugger = {
          #   name = "lldb-vscode";
          #   transport = "stdio";
          #   command = "lldb-vscode";
          #   # templates = [
          #   #   {
          #   #     name = "binary";
          #   #     request = "launch";
          #   #     completion = [
          #   #       {
          #   #         name = "binary";
          #   #         completion = "filename";
          #   #       }
          #   #     ];
          #   #     args = {
          #   #       program = "{0}";
          #   #       console = "internalConsole";
          #   #       stopOnEntry = false;
          #   #     };
          #   #   }
          #   # ];
          # };
        }
        {
          name = "python";
          scope = "source.python";
          file-types = ["py" "pyi" "py3" "pyw"];
          auto-format = true;
          language-servers = ["pyright" "ruff"];
          formatter = {
            command = lib.getExe pkgs.ruff;
            args = ["format" "--line-length" "88" "-"];
          };
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = ["typescript-language-server"];
          formatter = {
            command = lib.getExe pkgs.nodePackages.prettier;
            args = ["--parser" "typescript"];
          };
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = ["typescript-language-server"];
          formatter = {
            command = lib.getExe pkgs.nodePackages.prettier;
            args = ["--parser" "javascript"];
          };
        }
        {
          name = "c";
          auto-format = true;
          language-servers = ["clangd"];
          # debugger = {
          #   name = "lldb-vscode";
          #   transport = "stdio";
          #   command = "lldb-vscode";
          # };
        }
        {
          name = "cpp";
          auto-format = true;
          language-servers = ["clangd"];
          # debugger = {
          #   name = "lldb-vscode";
          #   transport = "stdio";
          #   command = "lldb-vscode";
          # };
        }
        {
          name = "zig";
          auto-format = true;
          language-servers = ["zls"];
          formatter = {
            command = lib.getExe pkgs.zig;
            args = ["fmt" "--stdin"];
          };
        }
        {
          name = "kdl";
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.kdlfmt;
          };
        }
        {
          name = "toml";
          auto-format = true;
          language-servers = ["taplo"];
        }
        {
          name = "yaml";
          auto-format = true;
          language-servers = ["yaml-language-server"];
        }
        {
          name = "bash";
          auto-format = true;
          language-servers = ["bash-language-server"];
          formatter = {
            command = lib.getExe pkgs.shfmt;
            args = ["-i" "2"];
          };
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = ["marksman"];
        }
        {
          name = "dockerfile";
          auto-format = true;
          language-servers = ["dockerfile-language-server-nodejs"];
        }
      ];
    };
  };
}
