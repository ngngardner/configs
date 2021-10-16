{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gowrap";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "hexdigest";
    repo = "gowrap";
    rev = "v${version}";
    sha256 = "0lnzigrzzsdxm7krh3hvs35xc2qwh0ks7y5dp6xw5js7a5ds7gkp";
  };

  vendorSha256 = sha256:ymEKGF8W5ZjQtRh8jec7gfPkyMb0m3nbgm3GqcjUG+Q=;

  meta = with lib; {
    inherit version;
    description = "GoWrap is a command line tool for generating decorators for Go interfaces.";
    homepage = "https://github.com/hexdigest/gowrap";
    license = licenses.mit;
  };
}
