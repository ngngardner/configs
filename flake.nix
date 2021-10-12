{
  description = "Nix configs";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/4df9f1a69b1b5d9d79d7d407c4998887c54cc2f4";
    };
    utils = { url = "github:numtide/flake-utils"; };
    compat = { url = "github:edolstra/flake-compat"; flake = false; };
    # python
    pylatex-flake = { url = "github:JelteF/PyLaTeX"; flake = false; };
    pyjulia-flake = { url = "github:JuliaPy/pyjulia"; flake = false; };
  };

  outputs = { self, nixpkgs, utils, compat, pylatex-flake, pyjulia-flake }:
    {
      overlay = final: prev: {
        pylatex = final.callPackage ./python/pylatex.nix { inherit pylatex-flake; };
        pyjulia = final.callPackage ./python/pyjulia.nix { inherit pyjulia-flake; };
      };
    } //
    (utils.lib.eachDefaultSystem
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
