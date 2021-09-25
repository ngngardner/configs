{ pkgs }:
pkgs.mkShell {
  packages = [
    pkgs.python39
    pkgs.pylatex

    # nix dev
    pkgs.nixpkgs-fmt
  ];
}