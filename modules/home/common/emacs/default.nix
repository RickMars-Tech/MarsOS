{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    extraPackages = epkgs:
      with epkgs; [
        # Gestión de paquetes y configuración
        use-package

        # Interfaz y temas
        doom-themes
        doom-modeline
        all-the-icons
        dashboard
        which-key

        # Navegación y búsqueda
        ivy
        counsel
        swiper
        projectile
        counsel-projectile

        # Autocompletado y snippets
        company
        company-box
        yasnippet
        yasnippet-snippets

        # LSP (Language Server Protocol)
        lsp-mode
        lsp-ui
        lsp-ivy
        dap-mode

        # Control de versiones
        magit

        # Syntax highlighting mejorado
        tree-sitter
        tree-sitter-langs

        # Lenguajes específicos
        # Nix
        nix-mode

        # Rust
        rust-mode
        cargo

        # Python
        python-mode
        pyvenv

        # C/C++
        ccls
        cmake-mode

        # Otros lenguajes útiles
        yaml-mode
        json-mode
        markdown-mode

        # Utilidades adicionales
        flycheck
        smartparens
        rainbow-delimiters
        exec-path-from-shell

        # Org mode mejorado
        org-bullets
        org-roam
      ];

    extraConfig = ''
      ;; Configuración básica
      (setq inhibit-startup-message t)
      (setq ring-bell-function 'ignore)
      (tool-bar-mode -1)
      (menu-bar-mode -1)
      (scroll-bar-mode -1)
      (global-display-line-numbers-mode 1)
      (setq display-line-numbers-type 'relative)
      (global-hl-line-mode 1)

      ;; Configuración de fuentes
      (set-face-attribute 'default nil :height 110)

      ;; Use-package setup
      (require 'use-package)
      (setq use-package-always-ensure t)

      ;; Tema
      (use-package doom-themes
        :config
        (setq doom-themes-enable-bold t
              doom-themes-enable-italic t)
        (load-theme 'doom-one t)
        (doom-themes-visual-bell-config)
        (doom-themes-org-config))

      ;; Modeline
      (use-package doom-modeline
        :init (doom-modeline-mode 1)
        :config
        (setq doom-modeline-height 25))

      ;; Iconos
      (use-package all-the-icons)

      ;; Dashboard
      (use-package dashboard
        :config
        (dashboard-setup-startup-hook)
        (setq dashboard-startup-banner 'logo
              dashboard-center-content t
              dashboard-items '((recents . 5)
                               (bookmarks . 5)
                               (projects . 5))))

      ;; Which-key
      (use-package which-key
        :init (which-key-mode)
        :config
        (setq which-key-idle-delay 0.3))

      ;; Ivy, Counsel, Swiper
      (use-package ivy
        :bind (("C-s" . swiper)
               :map ivy-minibuffer-map
               ("TAB" . ivy-alt-done)
               ("C-l" . ivy-alt-done)
               ("C-j" . ivy-next-line)
               ("C-k" . ivy-previous-line)
               :map ivy-switch-buffer-map
               ("C-k" . ivy-previous-line)
               ("C-l" . ivy-done)
               ("C-d" . ivy-switch-buffer-kill)
               :map ivy-reverse-i-search-map
               ("C-k" . ivy-previous-line)
               ("C-d" . ivy-reverse-i-search-kill))
        :config
        (ivy-mode 1)
        (setq ivy-use-virtual-buffers t
              ivy-wrap t
              ivy-count-format "(%d/%d) "
              enable-recursive-minibuffers t))

      (use-package counsel
        :bind (("M-x" . counsel-M-x)
               ("C-x b" . counsel-ibuffer)
               ("C-x C-f" . counsel-find-file)
               :map minibuffer-local-map
               ("C-r" . 'counsel-minibuffer-history))
        :config
        (counsel-mode 1))

      ;; Projectile
      (use-package projectile
        :config
        (projectile-mode +1)
        :bind-keymap
        ("C-c p" . projectile-command-map))

      (use-package counsel-projectile
        :config
        (counsel-projectile-mode))

      ;; Company (autocompletado)
      (use-package company
        :init (global-company-mode)
        :config
        (setq company-minimum-prefix-length 1
              company-idle-delay 0.0
              company-selection-wrap-around t
              company-tooltip-align-annotations t)
        :bind
        (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("TAB" . company-complete-common-or-cycle)
              ("<tab>" . company-complete-common-or-cycle)))

      (use-package company-box
        :hook (company-mode . company-box-mode))

      ;; YASnippet
      (use-package yasnippet
        :config
        (yas-global-mode 1))

      (use-package yasnippet-snippets)

      ;; LSP Mode
      (use-package lsp-mode
        :init
        (setq lsp-keymap-prefix "C-c l")
        :hook ((rust-mode . lsp)
               (python-mode . lsp)
               (c-mode . lsp)
               (c++-mode . lsp)
               (nix-mode . lsp)
               (lsp-mode . lsp-enable-which-key-integration))
        :commands lsp
        :config
        (setq lsp-completion-enable-additional-text-edit nil
              lsp-signature-auto-activate nil
              lsp-signature-render-documentation nil
              lsp-eldoc-hook nil
              lsp-modeline-code-actions-enable nil
              lsp-modeline-diagnostics-enable nil
              lsp-headerline-breadcrumb-enable nil
              lsp-semantic-tokens-enable nil
              lsp-enable-symbol-highlighting nil
              lsp-enable-on-type-formatting nil
              lsp-lens-enable nil
              lsp-folding-range-limit 100))

      (use-package lsp-ui
        :hook (lsp-mode . lsp-ui-mode)
        :config
        (setq lsp-ui-sideline-enable nil
              lsp-ui-doc-enable nil))

      (use-package lsp-ivy
        :commands lsp-ivy-workspace-symbol)

      ;; DAP Mode (debugging)
      (use-package dap-mode
        :config
        (dap-auto-configure-mode))

      ;; Tree-sitter (syntax highlighting mejorado)
      (use-package tree-sitter
        :config
        (global-tree-sitter-mode)
        (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

      (use-package tree-sitter-langs)

      ;; Flycheck (syntax checking)
      (use-package flycheck
        :init (global-flycheck-mode))

      ;; Smartparens
      (use-package smartparens
        :config
        (require 'smartparens-config)
        (smartparens-global-mode t))

      ;; Rainbow delimiters
      (use-package rainbow-delimiters
        :hook (prog-mode . rainbow-delimiters-mode))

      ;; Magit
      (use-package magit
        :bind ("C-x g" . magit-status))

      ;; Configuración específica por lenguaje

      ;; Nix
      (use-package nix-mode
        :mode "\\.nix\\'")

      ;; Rust
      (use-package rust-mode
        :config
        (setq rust-format-on-save t))

      (use-package cargo
        :hook (rust-mode . cargo-minor-mode))

      ;; Python
      (use-package python-mode
        :config
        (setq python-shell-interpreter "python3"))

      (use-package pyvenv
        :config
        (pyvenv-mode 1))

      ;; C/C++
      (use-package ccls
        :hook ((c-mode c++-mode objc-mode cuda-mode) .
               (lambda () (require 'ccls) (lsp))))

      (use-package cmake-mode)

      ;; Configuraciones adicionales
      (use-package yaml-mode)
      (use-package json-mode)
      (use-package markdown-mode)

      ;; Org mode
      (use-package org-bullets
        :hook (org-mode . org-bullets-mode))

      ;; Configuración de PATH para macOS/Linux
      (when (memq window-system '(mac ns x))
        (exec-path-from-shell-initialize))

      ;; Keybindings personalizados
      (global-set-key (kbd "C-x C-b") 'counsel-ibuffer)
      (global-set-key (kbd "M-y") 'counsel-yank-pop)

      ;; Configuración de backup files
      (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
      (setq delete-old-versions -1)
      (setq version-control t)
      (setq vc-make-backup-files t)
      (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

      ;; Configuraciones de rendimiento
      (setq gc-cons-threshold (* 2 1000 1000))
    '';
  };

  # Servicios necesarios para LSP
  home.packages = with pkgs; [
    # Language servers
    nil # Nix LSP
    rust-analyzer # Rust LSP
    python3Packages.python-lsp-server # Python LSP
    ccls # C/C++ LSP

    # Herramientas adicionales
    ripgrep # Para búsquedas rápidas
    fd # Para encontrar archivos

    # Formatters
    rustfmt # Rust formatter
    black # Python formatter
    clang-tools # C/C++ formatter
  ];
}
