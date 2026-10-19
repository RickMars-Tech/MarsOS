{
  flake.wrapperModules.hxLangs =
    { pkgs, lib,... }:
    let
      formatters = {
        nixfmt = lib.getExe pkgs.nixfmt-rs;
        biome = "${pkgs.biome}/bin/biome";
        oxfmt = "${pkgs.oxfmt}/bin/oxfmt";
        shfmt = "${pkgs.shfmt}/bin/shfmt";
        ruff = "${pkgs.ruff}/bin/ruff";
      };

      languageServers = {
        astro-ls = "${pkgs.astro-language-server}/bin/astro-ls";
        biome = "${pkgs.biome}/bin/biome";
        marksman = "${pkgs.marksman}/bin/marksman";
        nixd = "${pkgs.nixd}/bin/nixd";
        tailwindcss = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
        volar = "${pkgs.vue-language-server}/bin/vue-language-server";
        ruff = "${pkgs.ruff}/bin/ruff";
      };
    in
    {
      config = {
        languages = {
          language = [
            {
              name = "bash";
              auto-format = true;
              formatter = {
                command = formatters.shfmt;
                args = [
                  "-i"
                  "2"
                ];
              };
            }
            {
              name = "yaml";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.yaml"
                ];
              };
            }
            {
              name = "astro";
              auto-format = true;
              formatter = {
                command = formatters.biome;
                args = [
                  "format"
                  "--stdin-file-path"
                  "a.astro"
                ];
              };
              language-servers = [
                "astro-ls"
                "tailwindcss"
              ];
            }
            {
              name = "javascript";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.js"
                ];
              };
              language-servers = [
                "biome"
                "tailwindcss"
              ];
            }
            {
              name = "json";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.json"
                ];
              };
              language-servers = [ "biome" ];
            }
            {
              name = "jsx";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.jsx"
                ];
              };
              language-servers = [
                "biome"
                "tailwindcss"
              ];
            }
            {
              name = "markdown";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.md"
                ];
              };
              language-servers = [ "marksman" ];
            }
            {
              name = "typescript";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.ts"
                ];
              };
              language-servers = [
                "biome"
                "tailwindcss"
              ];
            }
            {
              name = "tsx";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.tsx"
                ];
              };
              language-servers = [
                "biome"
                "tailwindcss"
              ];
            }
            {
              name = "css";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.css"
                ];
              };
              language-servers = [
                "biome"
                "tailwindcss"
              ];
            }
            {
              name = "html";
              auto-format = true;
              formatter = {
                command = formatters.oxfmt;
                args = [
                  "--stdin-filepath"
                  "file.html"
                ];
              };
              language-servers = [ "tailwindcss" ];
            }
            {
              name = "python";
              auto-format = true;
              formatter = {
                command = formatters.ruff;
                args = [
                  "format"
                  "--line-length"
                  "88"
                  "-"
                ];
              };
              language-servers = [ "ruff" ];
            }
            {
              name = "nix";
              auto-format = true;
              formatter = {
                command = formatters.nixfmt;
                args = [ "-q" ];
              };
              language-servers = [ "nixd" ];
            }
          ];

          language-server = {
            astro-ls = {
              command = languageServers.astro-ls;
              args = [ "--stdio" ];
            };
            biome = {
              command = languageServers.biome;
              args = [ "lsp-proxy" ];
            };
            nixd = {
              command = languageServers.nixd;
              config.nixd.formatting.command = [
                formatters.nixfmt
                "-q"
              ];
            };
            ruff = {
              command = languageServers.ruff;
              args = [ "server" ];
            };
            marksman = {
              command = languageServers.marksman;
            };
            tailwindcss = {
              command = languageServers.tailwindcss;
              args = [ "--stdio" ];
            };
          };
        };
      };
    };
}
