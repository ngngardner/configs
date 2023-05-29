final: prev: {
  rome = (prev.callPackage ./rome.nix {}).rome;
  wemake-python-styleguide = (prev.callPackage ./wemake-python-styleguide.nix {}).wemake-python-styleguide;
}
