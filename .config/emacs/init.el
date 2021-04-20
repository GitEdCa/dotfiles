(require 'package)
;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(global-hl-line-mode +1)
; supress startup screen
(setq inhibit-startup-message t)
;Suppress Windows annoying beep or bell - Visible bell
(setq-default visible-bell t)
;Do not open file or user dialog.
(setq use-file-dialog nil)
(setq use-dialog-box nil)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Libraries
;(use-package evil
;  :ensure t
;  :init
;    (setq evil-want-C-u-scroll t)
;  :config
;  (evil-mode))

(use-package helm
  :ensure t
  :bind (("<f1>" . helm-find-files)
         ("<f4>" . helm-buffers-list)
         ("<f5>" . helm-show-kill-ring)
         ("<f6>" . helm-bookmarks)
         ("M-x" . helm-M-x))
  :config
  (helm-mode 1)
  (require 'helm-config)
  (setq-default helm-M-x-fuzzy-match t))

; find-file-in-project
(use-package find-file-in-project
  :ensure t
  :init
    (setq ffip-use-rust-fd t)
  :bind (("C-x f" . find-file-in-project)))

(add-hook 'ffip-diff-mode-hook 'ffip-diff-mode-hook-setup)
	
;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; Org mode
(use-package org
  :ensure t)

(defun my-compile ()
  (interactive)
  ;; Switch to `*shell*'
  (shell)
  ;; Goto last prompt, clear old input if any, and insert new one
  (goto-char (point-max))
  (comint-kill-input)
  (insert "build")
  ;; Execute
  (comint-send-input))

(global-set-key (kbd "M-m") 'my-compile)

(defun eshell-execute-selection ()
  "Insert text of current selection or clipboard in eshell and execute."
  (interactive)
  (require 'eshell)
  (let ((command (or (buffer-substring (mark) (point))
         x-last-selected-text-clipboard)))
    (let ((buf (current-buffer)))
      (unless (get-buffer eshell-buffer-name)
        (eshell))
      (display-buffer eshell-buffer-name t)
      (switch-to-buffer-other-window eshell-buffer-name)
      (end-of-buffer)
      (eshell-kill-input)
      (insert command)
      (eshell-send-input)
      (end-of-buffer)
      (switch-to-buffer-other-window buf))))


(use-package dumb-jump
;  :bind
;  (:map evil-motion-state-map
;        ("C-]" . 'dumb-jump-go)
;        ("C-}" . 'dumb-jump-go-prompt))
  :config
  (setq dumb-jump-prefer-searcher 'ag)
  :ensure)


(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (ido-mode 1))
