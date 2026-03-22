{pkgs, ...}: let
  formatters = {
    alejandra = "${pkgs.alejandra}/bin/alejandra";
    biome = "${pkgs.biome}/bin/biome";
    oxfmt = "${pkgs.oxfmt}/bin/oxfmt";
    shfmt = "${pkgs.shfmt}/bin/shfmt";
  };

  languageServers = {
    astro-ls = "${pkgs.astro-language-server}/bin/astro-ls";
    biome = "${pkgs.biome}/bin/biome";
    marksman = "${pkgs.marksman}/bin/marksman";
    nil = "${pkgs.nil}/bin/nil";
    tailwindcss = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
    volar = "${pkgs.vue-language-server}/bin/vue-language-server";
  };
in
  (pkgs.formats.toml {}).generate "languages.toml" {
    language = [
      {
        name = "bash";
        auto-format = true;
        formatter = {
          command = formatters.shfmt;
          args = ["-i" "2"];
        };
      }
      {
        name = "yaml";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.yaml"];
        };
      }
      {
        name = "astro";
        auto-format = true;
        formatter = {
          command = formatters.biome;
          args = ["format" "--stdin-file-path" "a.astro"];
        };
        language-servers = ["astro-ls" "tailwindcss"];
      }
      {
        name = "javascript";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.js"];
        };
        language-servers = ["biome" "tailwindcss"];
      }
      {
        name = "json";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.json"];
        };
        language-servers = ["biome"];
      }
      {
        name = "jsx";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.jsx"];
        };
        language-servers = ["biome" "tailwindcss"];
      }
      {
        name = "markdown";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.md"];
        };
        language-servers = ["marksman"];
      }
      {
        name = "typescript";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.ts"];
        };
        language-servers = ["biome" "tailwindcss"];
      }
      {
        name = "tsx";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.tsx"];
        };
        language-servers = ["biome" "tailwindcss"];
      }
      {
        name = "css";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.css"];
        };
        language-servers = ["biome" "tailwindcss"];
      }
      {
        name = "html";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.html"];
        };
        language-servers = ["tailwindcss"];
      }
      {
        name = "vue";
        auto-format = true;
        formatter = {
          command = formatters.oxfmt;
          args = ["--stdin-filepath" "file.vue"];
        };
        language-servers = ["volar" "tailwindcss"];
      }
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = formatters.alejandra;
          args = ["-q"];
        };
        language-servers = ["nil"];
      }
    ];

    language-server = {
      astro-ls = {
        command = languageServers.astro-ls;
        args = ["--stdio"];
      };
      biome = {
        command = languageServers.biome;
        args = ["lsp-proxy"];
      };
      nil = {
        command = languageServers.nil;
        config.nil.formatting.command = [formatters.alejandra "-q"];
      };
      marksman = {
        command = languageServers.marksman;
      };
      tailwindcss = {
        command = languageServers.tailwindcss;
        args = ["--stdio"];
      };
      volar = {
        command = languageServers.volar;
        args = ["--stdio"];
      };
    };
  }
