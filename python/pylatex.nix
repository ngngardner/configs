{ lib, python3Packages, pylatex_src }:

python3Packages.buildPythonApplication rec {
  pname = "pylatex";
  version = "1.3.4";

  src = pylatex_src;

  propagatedBuildInputs = with python3Packages; [
    ordered-set
  ];

  meta = with lib; {
    inherit (pylatex_src) homepage description version;
    license = licenses.mit;
  };
}
