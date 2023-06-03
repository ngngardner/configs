{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixago = {
      url = "github:jmgilman/nixago";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixago-exts = {
      url = "github:nix-community/nixago-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rtx-flake = {
      url = "github:jdxcode/rtx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit
      (inputs)
      nixpkgs
      flake-parts
      devshell
      home-manager
      nixago
      nixago-exts
      ;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        devshell.flakeModule
      ];
      perSystem = {
        self',
        system,
        inputs',
        lib,
        config,
        pkgs,
        ...
      }: let
        configs = import ./.config.nix {
          inherit pkgs system nixago-exts;
        };
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
          overlays = [
            (import ./nix/packages/overlays.nix)
            inputs.rtx-flake.overlay
            inputs.naersk.overlay
            (_: _: {
              nil = inputs'.nil.packages.default;
              poetry2nix = inputs'.poetry2nix.legacyPackages;
            })
          ];
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.rtx
            pkgs.lefthook
            pkgs.nvfetcher
            pkgs.topiary

            (pkgs.python3.withPackages (ps: [
              pkgs.wemake-python-styleguide
            ]))
          ];
          shellHook = ''
            ${(nixago.lib.${system}.makeAll configs).shellHook}
          '';
        };

        legacyPackages = {
          homeConfigurations.noah = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./nix/home/home.nix
            ];
          };
        };
      };
    };

  nixConfig = {
    max-jobs = "auto";
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
