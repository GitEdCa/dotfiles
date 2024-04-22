(setq inhibit-startup-screen t)
(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

(load-theme 'gruber-darker)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

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
(ido-everywhere 1)
(ido-ubiquitous-mode 1)
(require 'ido-completing-read+)
(ido-ubiquitous-mode 1)

(require 'icomplete)
(icomplete-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e13beeb34b932f309fb2c360a04a460821ca99fe58f69e65557d6c1b10ba18c7" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
