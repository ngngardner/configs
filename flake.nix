{
  description = "Nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    flake-utils = { url = "github:numtide/flake-utils"; };
    pylatex_src = {
      url = "github:JelteF/PyLaTeX";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, pylatex_src }:
    {
      overlay = final: prev: {
        pylatex = final.callPackage ./python/pylatex.nix { inherit pylatex_src; };
      };
    } //
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
            ];
          };
        in
        {
          devShell = import ./shell.nix { inherit pkgs;};
        })
    );
}