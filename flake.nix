{
  description = "Home Manager configuration of Jane Doe";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.devshell.inputs.flake-utils.follows = "flake-utils";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.rtx-flake = {
    url = "github:chadac/rtx/add-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    devshell,
    home-manager,
    rtx-flake,
    ...
  }: let
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        rtx-flake.overlay
        devshell.overlays.default
      ];
    };
  in {
    homeConfigurations.noah = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
      ];
    };

    devShell = pkgs.devshell.mkShell {
      imports = [(pkgs.devshell.importTOML ./devshell.toml)];
    };
  };
}
