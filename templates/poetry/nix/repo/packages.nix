{
  inputs,
  cell,
}: let
  inherit (inputs) self;
  inherit (cell.lib) nixpkgs;
in {
  # CONFIGURE-ME
  env = nixpkgs.poetry2nix.mkPoetryEnv {
    projectDir = self;
    overrides = nixpkgs.poetry2nix.overrides.withDefaults (import ./overrides.nix);
  };
}
