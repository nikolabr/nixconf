{
  description = "Home manager and system configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;
    
    homeConfigurations = {
      "nikola" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        modules = [ ./home.nix ];
      };
    };
  };
}
