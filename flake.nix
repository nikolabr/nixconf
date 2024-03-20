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

    nil = {
      url = "github:oxalica/nil";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, rust-overlay, nil, ... }@inputs:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays =
          [ emacs-overlay.overlays.default rust-overlay.overlays.default nil.overlays.default ];
        config.allowUnfree = true;
      };
      
    in {
      packages.x86_64-linux.custom-emacs = (import ./emacs.nix { inherit pkgs; });
      nixosConfigurations = {
        thinkbook = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.nikola = import ./home.nix;

              home-manager.extraSpecialArgs = {
                inherit inputs pkgs;
              };
            }
          ];
          
          specialArgs = { inherit inputs; };
        };
      };
    };
}
