/*
This file holds reproducible shells with commands in them.

They conveniently also generate config files in their startup hook.
*/
{
  inputs,
  cell,
}: let
  inherit (inputs.std) lib;
  inherit (cell.lib) nixpkgs;
in {
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "CONFIGURE-ME";

    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = (map (x: (lib.dev.mkNixago x))) [
      (lib.cfg.conform // cell.configs.conform)
      (lib.cfg.mdbook // cell.configs.mdbook)
      (lib.cfg.treefmt // cell.configs.treefmt)
      (lib.cfg.editorconfig // cell.configs.editorconfig)
      (lib.cfg.lefthook // cell.configs.lefthook)

      cell.configs.vscode.extensions
      cell.configs.vscode.settings
    ];

    packages = with nixpkgs; [
      poetry
      env
    ];
  };
}
