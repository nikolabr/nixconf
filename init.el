(setq custom-file (concat user-emacs-directory "/custom.el"))

(scroll-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode -1)
(desktop-save-mode 1)
(electric-pair-mode 1)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-include-diary t)

(setq ispell-program-name "aspell")
(setq ispell-dictionary "slovenian")

(add-hook 'org-mode-hook
	  (lambda ()
	    (flyspell-mode 1)
	    )
	  )

(setq auth-source-save-behavior nil)

(require 'package)
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  )

(setq custom-safe-themes t)
(color-theme-sanityinc-tomorrow-night)

(use-package helm)
  ;; :bind (
  ;; 	 ([remap find-filepp] . #'helm-find-files)
  ;; 	 ([remap execute-extended-command] . #'helm-M-x)
  ;; 	 ([remap switch-to-buffer] . #'helm-mini)
  ;; )


(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)

(define-key helm-map (kbd "TAB") 'helm-next-line)
(define-key helm-map (kbd "<backtab>") 'helm-previous-line)

(use-package helm-xref
  :after (helm)
  )

(helm-mode)

(use-package lsp-mode
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-idle-delay 0.1)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode)
  )

(use-package helm-lsp
  :after (lsp-mode)
  :config
  )

(use-package rust-mode)

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'js-mode-hook 'lsp)

(use-package yasnippet)

(use-package which-key
  :config (which-key-mode)
  )

(use-package projectile
  :config (projectile-mode)
  ;; :bind (:map projectile-mode-map
  ;; 	      ("C-c p" . 'projectile-command-map)
  ;; 	      )
  )

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Automated project discovery
(setq projectile-project-search-path '("~/Dev/"))

;; Disable the stm32 extension for now 
;; (add-hook 'after-init-hook (lambda ()
;; 			     (require 'stm32)
;; 			     (setq stm32-cubemx "stm32cubemx")
;; 			     ))

(use-package hydra)

(use-package flycheck)

(use-package company
  :config
  (setq company-idle-delay 0.0)
  (setq company-minimum-prefix-length 1)
  )

(use-package avy)

(use-package magit)

;; Fix for magit
(if (version< "28" emacs-version)
    (defun seq-keep (function sequence)
      "Apply FUNCTION to SEQUENCE and return the list of all the non-nil results."
      (delq nil (seq-map function sequence)))
)

(use-package mozc)

(use-package dap-mode)

(use-package slime
  :config
  (setq inferior-lisp-program "sbcl")
  )

(use-package pdf-tools
  :config
  (pdf-tools-install)
  )

(use-package calfw)
(use-package calfw-cal)
(use-package calfw-org)
(setq european-calendar-style 't)
(setq org-agenda-files (list "~/org/"))
(setq cfw:org-agenda-schedule-args '(:timestamp))

(cfw:open-calendar-buffer
 :contents-sources
 (list
  (cfw:cal-create-source "IndianRed") ; diary source
  (cfw:org-create-source "Green") ; org source
  )
 :view 'week)


