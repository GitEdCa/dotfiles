;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "https://melpa.org/packages/")
  (require 'use-package))

;expand-region
(use-package expand-region
  :ensure t  
  :bind ("C-=" . er/expand-region))
; apply grep
 (grep-apply-setting 'grep-find-command  '("rg -n -H --no-heading -e '' $(git rev-parse --show-toplevel || pwd)" . 27))

(global-hl-line-mode 1)
;set theme
(set-face-background 'hl-line "midnight blue")
(load-theme 'deeper-blue)

(setq compilation-directory-locked nil)
(scroll-bar-mode -1)
(setq shift-select-mode nil)
(setq enable-local-variables nil)

(display-battery-mode 1)

; avoid welcome page
(setq inhibit-startup-screen t)
; Turn off the toolbar
(tool-bar-mode 0)

; activate ido mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

; Setup my find-files
(define-key global-map "\ef" 'ido-find-file)
(define-key global-map "\eF" 'ido-find-file-other-window)

(global-set-key (read-kbd-macro "\eb")  'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB")  'ido-switch-buffer-other-window)

; save buffers
(define-key global-map "\es" 'save-buffer)

; Move windows with meta
(setq ediff-split-window-function 'split-window-vertically)

; Turn off the bell on Mac OS X
(defun nil-bell ())
(setq ring-bell-function 'nil-bell)

;; Org mode
(use-package org
	     :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(expand-region ace-jump-mode org use-package helm-projectile general fzf evil-leader dumb-jump doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
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
