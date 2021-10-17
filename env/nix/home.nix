# ~/.config/nixpkgs/home.nix
{ pkgs, ... }:
let
  pythonPackages = with pkgs.python39Packages; [
    autopep8
    flake8
    mypy
  ];
in
{
  programs.home-manager.enable = true;
  home.packages = [
    pkgs.direnv
    pkgs.nixpkgs-fmt
  ] ++ pythonPackages;
}
