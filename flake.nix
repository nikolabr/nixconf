{
  description = "Home manager and system configurations";

  inputs = rec {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay, rust-overlay }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          emacs-overlay.overlays.default
          rust-overlay.overlays.default
        ];
        config.allowUnfree = true;
      };
    in {
      packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;

      homeConfigurations = {
        "nikola" = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home.nix ];
          inherit pkgs;
        };
      };
    };
}
