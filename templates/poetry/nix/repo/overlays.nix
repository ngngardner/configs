{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs poetry2nix;

  system = nixpkgs.system;
in {
  default = final: prev: {
    poetry2nix = poetry2nix.legacyPackages.${system};
    env = cell.packages.env;
  };
}
