{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "pyjulia";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "JuliaPy";
    repo = "pyjulia";
    rev = "v${version}";
    sha256 = "0qngc69f0vbk0gw775yknm9624bk94bw7g4jllapkypyx12206pb";
  };

  meta = with lib; {
    inherit version;
    description = "Python interface to Julia.";
    homepage = "https://github.com/JuliaPy/pyjulia";
    license = licenses.mit;
  };
}
