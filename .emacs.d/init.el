(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;;; Set up the package manager
(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq use-package-always-ensure t)  ;; always ensure t packages

(setq inhibit-startup-message t)     ;; no welcome dashboard 
(global-hl-line-mode 1)              ;; hightline current line
(global-display-line-numbers-mode 1) ;; display number mode
(defalias 'yes-or-no-p 'y-or-n-p)    ;; use y or n for prompts
(global-subword-mode 1)              ;; moving cursor throw CamelCase and snake_case with ease

;; no gui
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Replace when marked
(use-package delsel
  :hook (after-init . delete-selection-mode))


(let ((mono-spaced-font "Iosevka Nerd Font Mono")
      (proportionately-spaced-font "Sans"))
  (set-face-attribute 'default nil :family mono-spaced-font :height 120)
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))

;; disable backups and autosave
(setq make-backup-files nil)
(setq auto-save-default nil)

;; auto close bracket insertion
(electric-pair-mode 1)

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
	(line (let ((s (thing-at-point 'line t)))
		(if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))
(global-set-key (kbd "M-t") 'rc/duplicate-line)

(when (eq system-type 'windows-nt)
  (let ((xlist
	 '(
	   "C:/Program Files/PowerShell/7/pwsh.exe"
	   "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
	   ))
	xfound)
    (setq xfound (seq-some (lambda (x) (if (file-exists-p x) x nil)) xlist))
    (when xfound (setq explicit-shell-file-name xfound))))

;; Ctrl-w to delete backward word or region
(defun kill-region-or-word ()
  "Call `kill-region' or `backward-kill-word' depending on
whether or not a region is selected."
  (interactive)
  (if (and transient-mark-mode mark-active)
      (kill-region (point) (mark))
    (backward-kill-word 1)))
(global-set-key "\C-w" 'kill-region-or-word)

(use-package ef-themes
  :if window-system
  :config
  ;; Enable the theme
  (load-theme 'ef-winter t))

;; Remember to do M-x and run `nerd-icons-install-fonts' to get the
;; font files.  Then restart Emacs to see the effect.
(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

  ;;; Configure the minibuffer and completions

(use-package vertico
  :hook (after-init . vertico-mode))

(use-package marginalia
  :hook (after-init . marginalia-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

(use-package savehist
  :hook (after-init . savehist-mode))

(use-package corfu
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :config
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)

  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

  ;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

  ;;; The file manager (Dired)

(use-package dired
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<b>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package expand-region
  :bind ("C-=" . 'er/expand-region)
  ("C--" . 'er/contract-region))

(use-package yasnippet
  :config
  (yas-global-mode 1)
  (setq yas-snippet-dirs '("$HOME/.emacs.d/snippets")))

(use-package gptel
  :config
  (setq gptel-api-key ""))

(use-package which-key
  :config
  (which-key-mode))

(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil))

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; multicursor and exapand selection
(use-package evil-multiedit
  :config
  (evil-multiedit-default-keybinds))

;; commentary
(use-package evil-commentary
  :config
  (evil-commentary-mode))

;; winum
(use-package winum
  :config
  (setq winum-scope 'frame-local)
  ;; (global-set-key (kbd "M-0") 'treemacs-select-window)
  (global-set-key (kbd "M-1") 'winum-select-window-1)
  (global-set-key (kbd "M-2") 'winum-select-window-2)
  (global-set-key (kbd "M-3") 'winum-select-window-3)
  (global-set-key (kbd "M-4") 'winum-select-window-4))

;; magit
(use-package magit
  :config
  (setq magit-log-section-commit-count 25
  magit-copy-revision-abbreviated t))

(use-package lsp-mode
    :hook (java-mode . lsp-deferred)
    :commands (lsp lsp-deferred))

