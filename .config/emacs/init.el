(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

(setq custom-file "~/.emacs.d/custom.el")
;; Prevent undo tree files from polluting your git repo
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

(add-to-list 'load-path "~/.emacs.d/better-defaults")
(require 'better-defaults)

;; Startup
(setq inhibit-startup-screen t)
(setq initial-scratch-message
      ";; Hello world.\n")

;; Zoom
(set-face-attribute 'default nil :height 110)

;; Save History
(savehist-mode +1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; magit
(use-package magit
  :ensure t)

(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
	     ("C--" . er/contract-region)))

;; evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (setq evil-insert-state-cursor 'box)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (evil-mode t))


(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

;;(use-package multiple-cursors
;;  :ensure t)

(use-package evil-mc
  :ensure t
  :after evil
  :config
  (global-evil-mc-mode  1)
  (progn
    (evil-define-key 'normal evil-mc-key-map (kbd "<escape>") 'evil-mc-undo-all-cursors)))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package vertico
  :ensure t
  :custom
  (vertico-count 13)                    ; Number of candidates to display
  (vertico-resize t)
  (vertico-cycle nil)
  :config
  (vertico-mode))

(use-package hotfuzz
  :ensure t
  :init
  (setq completion-styles '(hotfuzz)))

;; UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)

(use-package kuronami-theme
  :ensure t
  :config
  (load-theme 'kuronami t))

(use-package rainbow-mode
  :ensure t)

;; dired
(setq dired-dwim-target t)

;; editor config
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package emacs
  :config
  (blink-cursor-mode 0))

(use-package org-zettelkasten
  :ensure t
  :config
  (add-hook 'org-mode-hook #'org-zettelkasten-mode))
