{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "pylatex";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "JelteF";
    repo = "PyLaTeX";
    rev = "v${version}";
    sha256 = "11z5l5l1b3208w2x8ij5qzg68alk541v5rczwx69yn4f5h19svva";
  };

  propagatedBuildInputs = with python3Packages; [
    ordered-set
  ];

  meta = with lib; {
    inherit version;
    description = "A Python library for creating LaTeX files";
    homepage = "https://github.com/JelteF/PyLaTeX";
    license = licenses.mit;
  };
}
