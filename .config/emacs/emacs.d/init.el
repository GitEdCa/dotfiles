(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

(setq custom-file "~/.emacs.d/custom.el")
;; Prevent undo tree files from polluting your git repo
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; Zoom
(set-face-attribute 'default nil :height 120)

;; Save History
(savehist-mode +1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

;; Startup
(setq inhibit-startup-screen t)
(setq initial-scratch-message
      ";; Hello world.\n")

(load-theme 'gruber-darker t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; evil mode
(use-package evil
  :ensure t
  :config
  (evil-mode t)
  (setq evil-disable-insert-state-bindings 't))

(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

;; magit
(use-package magit
  :ensure t)

;; multiple cursors
(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->")         'mc/mark-next-like-this)
  (global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
  (global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
  (global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this))

;; move-text
(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-p") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down))

;; company
(use-package company
  :ensure t
  :hook (emacs-lisp-mode . company-tng-mode)
  :config
  (setq company-idle-delay 0.5
	company-minimum-prefix-length 2))

(use-package eglot
  :ensure t
  :demand t
  :bind (:map eglot-mode-map
	      ("<f6>" . eglot-format-buffer)
	      ("C-c a" . eglot-code-actions)
	      ("C-c d" . eldoc)
	      ("C-c r" . eglot-rename))
  :config
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider)))

(use-package c-ts-mode
  :ensure t
  :after (eglot)
  :hook ((c-ts-mode . eglot-ensure)
	 (c-ts-mode . company-tng-mode)
	 (c-ts-mode . (lambda ()
			(eglot-inlay-hints-mode -1))))
  :config
  (add-to-list 'eglot-server-programs '(c-ts-mode . ("clangd"
						     "--header-insertion=never"))))

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))

;; disable all bars
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; pretend like I have winum
(global-set-key (kbd "M-1") 'other-window)
(global-set-key (kbd "M-2") 'other-window)
(setq gdb-many-windows t) ; set gdb-many-windows on gdb automatically

(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
	 ("C--" . er/contract-region)))

;; ido
(ido-mode 1)
(setq ido-enable-flex-matching t)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)
(require 'ido-completing-read+)
(ido-ubiquitous-mode 1)

;; smx
(use-package amx
  :ensure t
  :config (amx-mode 1))

;; buffer autocomplete
(require 'icomplete)
(icomplete-mode 1)

;; Recent files
(recentf-mode 1)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
