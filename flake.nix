{
  description = "Nix configs";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/d189bf92f9be23f9b0f6c444f6ae29351bb7125c";
    };
    utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem
      (system:
        let
          overlay = import ./pkgs;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              overlay
            ];
          };
        in
        {
          devShell = pkgs.mkShell {
            packages = [
              pkgs.python39
              pkgs.gowrap
            ];
          };
        });
}
