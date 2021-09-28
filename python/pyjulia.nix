{ lib, python3Packages, pyjulia-flake }:

python3Packages.buildPythonApplication rec {
  pname = "pyjulia";
  version = "0.5.6";

  src = pyjulia-flake;

  meta = with lib; {
    inherit (pyjulia-flake) homepage description version;
    license = licenses.mit;
  };
}
