{
  description = "Nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    # python
    pylatex-flake = { url = "github:JelteF/PyLaTeX"; flake = false; };
    pyjulia-flake = { url = "github:JuliaPy/pyjulia"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, pylatex-flake, pyjulia-flake }:
    {
      overlay = final: prev: {
        pylatex = final.callPackage ./python/pylatex.nix { inherit pylatex-flake; };
        pyjulia = final.callPackage ./python/pyjulia.nix { inherit pyjulia-flake; };
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
              pkgs.pyjulia
            ];
          };
        })
    );
}
