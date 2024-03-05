{
  description = "Home manager and system configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, rust-overlay }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays =
          [ emacs-overlay.overlays.default rust-overlay.overlays.default ];
        config.allowUnfree = true;
      };

      emacsWithPackages =
        (pkgs.emacsPackagesFor pkgs.emacs-gtk).emacsWithPackages;

    in {
      packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;

      packages.x86_64-linux.custom-emacs = (emacsWithPackages (epkgs:
        (with epkgs; [
          color-theme-sanityinc-tomorrow

          direnv
          nix-mode
          rust-mode

          helm
          helm-xref

          lsp-mode
          helm-lsp
          dap-mode

          yasnippet
          which-key
          hydra
          flycheck
          company
          avy

          magit

          auctex
          
          mozc
          slime
          pdf-tools

          calfw
          calfw-cal
          calfw-org

          lsp-pyright

          sicp
          racket-mode
          paredit

          clojure-mode
          cider

          elm-mode

          weblio
          nov
        ])));

      homeConfigurations = {
        "nikola" = home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home.nix
            {
              services.emacs = {
                enable = true;
                defaultEditor = true;
                client.enable = true;

                package = self.packages.x86_64-linux.custom-emacs;
              };

              home.file.".emacs".source = ./init.el;
            }
          ];
          inherit pkgs;
        };
      };
    };
}
