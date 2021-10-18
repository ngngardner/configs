{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gowrap";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ngngardner";
    repo = "gowrap";
    rev = "bfffa3d31d93d3a8babb6efb12595abf2fd66e4f";
    sha256 = sha256:trqxzzdbrky4ZbobdN+g/z7VrVIvx8TAGpYUqkkJJfc=;
  };

  vendorSha256 = sha256:8UdPq1e0db1WAX35vS8eZoN2OjM6hCZSBGrc2km1v2Y=;
  CGO_ENABLED = 0;

  meta = with lib; {
    inherit version;
    description = "GoWrap is a command line tool for generating decorators for Go interfaces.";
    homepage = "https://github.com/hexdigest/gowrap";
    license = licenses.mit;
  };
}
