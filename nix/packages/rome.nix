{pkgs}: let
  sources = pkgs.callPackage ./_sources/generated.nix {};
in {
  rome = pkgs.naersk.buildPackage {
    src = sources.rome.src;
  };
}
