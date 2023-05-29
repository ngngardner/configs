{pkgs}: let
  sources = pkgs.callPackage ./_sources/generated.nix {};
in {
  wemake-python-styleguide = pkgs.poetry2nix.mkPoetryApplication {
    projectDir = sources.wemake-python-styleguide.src;

    overrides =
      pkgs.poetry2nix.defaultPoetryOverrides.extend
      (self: super: {
        attrs = pkgs.python3.pkgs.attrs;
        flake8-broken-line = super.flake8-broken-line.overridePythonAttrs (old: {
          buildInputs = (old.buildInputs or []) ++ [super.poetry];
        });
        flake8-eradicate = super.flake8-eradicate.overridePythonAttrs (old: {
          buildInputs = (old.buildInputs or []) ++ [super.poetry];
        });
        flake8-rst-docstrings = super.flake8-rst-docstrings.overridePythonAttrs (old: {
          buildInputs = (old.buildInputs or []) ++ [super.setuptools];
        });
      });
  };
}
