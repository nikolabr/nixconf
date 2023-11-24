{ config, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    client.enable = true;

    package = (pkgs.emacsWithPackagesFromUsePackage {
      config = "./init.el";
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
