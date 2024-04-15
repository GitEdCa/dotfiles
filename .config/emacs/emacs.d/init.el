(setq custom-file "~/.emacs.d/custom.el")
(load custom-file t)

(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

(load-theme 'tango-dark)

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

;;(use-package vertico
;;  :ensure t
;;  :config
;;  (vertico-mode 1))

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
