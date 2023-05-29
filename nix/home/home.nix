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
      nil
      ripgrep
      treefmt
      conform
      rome

      # python
      (pkgs.python3.withPackages (ps: [
        pkgs.wemake-python-styleguide
      ]))

      # for non-nix projects
      rtx

      # langs
      julia-bin
    ];

    username = username;
    homeDirectory = homedir;
    stateVersion = "22.11";
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
      stdlib = l.readFile ./direnvrc;
    };
    git = {
      enable = true;
      userName = "Noah Gardner";
      userEmail = "ngngardner@gmail.com";
    };
  };
}
