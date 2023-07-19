{
  pkgs,
  lib,
  ...
}: let
  username = "noah";
  homedir = "/home/noah";

  l = lib // builtins;
in {
  home = {
    packages = with pkgs; [
      # tooling
      alejandra
      direnv
      ripgrep
      treefmt
      conform
      topiary
      nixd

      # langs
      julia-bin
    ];

    username = username;
    homeDirectory = homedir;
    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
    starship.enable = true;
    bash = {
      enable = true;
      initExtra = l.readFile ./.bashrc;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "Noah Gardner";
      userEmail = "ngngardner@gmail.com";
    };
  };
}
