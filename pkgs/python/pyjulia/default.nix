{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "pyjulia";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "JuliaPy";
    repo = "pyjulia";
    rev = "v${version}";
    sha256 = sha256:7JE8xKryf7sjvlUjDH7jUMm7CyirjPbmWo+reWeGIlc=;
  };

  meta = with lib; {
    inherit version;
    description = "Python interface to Julia.";
    homepage = "https://github.com/JuliaPy/pyjulia";
    license = licenses.mit;
  };
}
