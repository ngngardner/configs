{
  description = "CONFIGURE-ME";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    std = {
      url = "github:divnix/std";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devshell.url = "github:numtide/devshell";
      inputs.nixago.url = "github:nix-community/nixago";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
    };
  };

  outputs = {std, ...} @ inputs:
    std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        (functions "lib")
        (functions "overlays")
        (runnables "packages")
        (nixago "configs")
        (devshells "shells")
      ];
    } {
      devShells = std.harvest inputs.self ["repo" "shells"];
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
