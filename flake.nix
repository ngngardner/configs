{
  description = "Nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    pylatex_src = {
      url = "github:JelteF/PyLaTeX";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, pylatex_src }:
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
          devShell = pkgs.mkShell {
            packages = [
              pkgs.python39
              pkgs.pylatex
            ];
          };
        })
    );
}