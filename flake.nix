{
  description = "Home manager and system configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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
  in {
    packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;

    homeConfigurations = {
      "nikola" = home-manager.lib.homeManagerConfiguration {
        modules = [
          ./home.nix
          {
            services.emacs = {
              enable = true;
              defaultEditor = true;
              client.enable = true;

              package = (pkgs.emacsWithPackagesFromUsePackage {
                config = ./init.el;
                defaultInitFile = true;
                alwaysEnsure = true;

                package = pkgs.emacs-gtk;

                # Optionally provide extra packages not in the configuration file.
                extraEmacsPackages = epkgs: [
                  epkgs.use-package
                  epkgs.melpaPackages.nix-mode
                ];
              });
            };
          }
          { home.stateVersion = "23.05"; }
        ];
        inherit pkgs;
      };
    };
  };
}
