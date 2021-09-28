{ lib, python3Packages, pylatex-flake }:

python3Packages.buildPythonApplication rec {
  pname = "pylatex";
  version = "1.3.4";

  src = pylatex-flake;

  propagatedBuildInputs = with python3Packages; [
    ordered-set
  ];

  meta = with lib; {
    inherit (pylatex-flake) homepage description version;
    license = licenses.mit;
  };
}
