{
  stdenv,
  fetchurl,
  fetchFromGitHub,
  lib,
  python3,
  python3Packages
}:

with lib;

let
  version = "0.2.0";
in
  python3Packages.buildPythonApplication {
    pname = "electrum-personal-server";
    inherit version;

    doCheck = false;

    src = fetchFromGitHub {
      owner = "chris-belcher";
      repo = "electrum-personal-server";
      rev = "eps-v${version}";
      sha256 = "0ysb0jhklv8m2bvkzm0w939vjdvwmc7zn53rai7yilvragzaq2w6";
    };

    propagatedBuildInputs = with python3Packages; [
      pytest
      pytestrunner
      setuptools
    ];

    meta = with stdenv.lib; {
      description = "";
      longDescription = ''
      '';
      homepage = "";
      license = licenses.mit;
      platforms = platforms.all;
      maintainers = ["Sean D Gillespie"];
    };
  }
