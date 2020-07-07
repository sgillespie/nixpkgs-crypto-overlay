{
  donateLevel ? 0,
  algorithm ? "rx/0",
  tls ? false,
  url,
  user,
  
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libuv,
  libmicrohttpd,
  openssl,
  hwloc
}:

let
  configFile = builtins.toFile "config.json" ''
    {
      "pools": [
        {
          "algo": "${algorithm}",
          "url": "${url}",
          "user": "${user}",
          "tls": ${tls},
        }
      ]
    }
  '';
in
  stdenv.mkDerivation rec {
    pname = "xmrig";
    version = "5.11.2";

    src = fetchFromGitHub {
      owner = "xmrig";
      repo = "xmrig";
      rev = "v${version}";
      sha256 = "06nxhrb5vnlq3sxybiyzdpbv6ah1zam7r07s1c31sv37znlb77d5";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ libuv libmicrohttpd openssl hwloc ];

    postPatch = ''
      substituteInPlace src/donate.h \
        --replace "kDefaultDonateLevel = 5;" "kDefaultDonateLevel = ${toString donateLevel};" \
        --replace "kMinimumDonateLevel = 1;" "kMinimumDonateLevel = ${toString donateLevel};"
    '';

    installPhase = ''
      install -vD xmrig $out/bin/xmrig
      runHook postInstall
    '';

    postInstall = ''
      cp ${configFile} $out/bin/config.json
    '';

    meta = with lib; {
      description = "Monero (XMR) CPU miner";
      homepage = "https://github.com/xmrig/xmrig";
      license = licenses.gpl3Plus;
      platforms   = [ "x86_64-linux" "x86_64-darwin" ];
      maintainers = with maintainers; [ fpletz kim0 ];
    };
  }
