(setq custom-file (concat user-emacs-directory "/custom.el"))

(scroll-bar-mode -1)
(tooltip-mode -1)
(tool-bar-mode -1)
(desktop-save-mode 1)
(electric-pair-mode 1)

(setq org-log-done t)
(setq org-agenda-include-diary t)

(setq diary-file "~/diary")

(setq ispell-program-name "aspell")
(setq ispell-dictionary "slovenian")

(add-hook 'org-mode-hook
	  (lambda ()
	    (flyspell-mode 1)
	    )
	  )

(setq auth-source-save-behavior nil)

(require 'package)
(setq package-archives nil)

(package-initialize)

(require 'color-theme-sanityinc-tomorrow)

(setq custom-safe-themes t)
(color-theme-sanityinc-tomorrow-night)

(require 'helm)
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

(require 'helm-xref)

(helm-mode)

(require 'lsp-mode)

(setq lsp-keymap-prefix "C-c l")
(define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
(setq lsp-idle-delay 0.1)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(require 'dap-cpptools)

(require 'helm-lsp)

(require 'rust-mode)

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'js-mode-hook 'lsp)

(require 'yasnippet)
(yas-global-mode)

(require 'which-key)
(which-key-mode)

(require 'projectile)
(projectile-mode)

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Automated project discovery
(setq projectile-project-search-path '("~/Dev/"))

;; Disable the stm32 extension for now 
;; (add-hook 'after-init-hook (lambda ()
;; 			     (require 'stm32)
;; 			     (setq stm32-cubemx "stm32cubemx")
;; 			     ))

(require 'hydra)

(require 'flycheck)

(require 'company)
(setq company-idle-delay 0.0)
(setq company-minimum-prefix-length 1)

(require 'avy)

(require 'magit)

;; Fix for magit
(if (version< "28" emacs-version)
    (defun seq-keep (function sequence)
      "Apply FUNCTION to SEQUENCE and return the list of all the non-nil results."
      (delq nil (seq-map function sequence)))
)

(require 'mozc)

(require 'dap-mode)

(require 'slime)
(setq inferior-lisp-program "sbcl")

(require 'pdf-tools)
(pdf-tools-install)

(require 'sicp)

(require 'racket-mode)

(require 'paredit)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)

(require 'clojure-mode)
(require 'cider)

(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)

(require 'calfw)
(require 'calfw-cal)
(require 'calfw-org)
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


