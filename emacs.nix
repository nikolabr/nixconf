{ pkgs, ...}:

let
  emacsWithPackages = (pkgs.emacsPackagesFor pkgs.emacs-gtk).emacsWithPackages;
in
  emacsWithPackages (epkgs:
    (with epkgs; [
      color-theme-sanityinc-tomorrow

      direnv nix-mode

      rust-mode

      helm helm-xref

      lsp-mode helm-lsp dap-mode

      yasnippet which-key hydra flycheck company avy

      magit

      auctex

      mozc slime pdf-tools

      calfw calfw-cal calfw-org

      lsp-pyright

      sicp racket-mode paredit

      clojure-mode cider

      tuareg
      
      elm-mode

      weblio nov

      mu4e
  ]))
    
