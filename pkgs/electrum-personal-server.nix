{
  masterPublicKeys ? {},
  watchOnlyAddresses ? {},
  bitcoinRpcPort,
  bitcoinRpcUser,
  bitcoinRpcPassword,
  bitcoinRpcWallet,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  lib,
  python3,
  python3Packages
}:

let
  inherit (lib) concatStringsSep mapAttrsToList pipe;
  foldAttrToIni = attr: pipe attr [
    (a: mapAttrsToList (k: v: "${k} = ${v}") a)
    (a: concatStringsSep "\n" a)
  ];
  version = "0.2.0";
  configFile = builtins.toFile "config.ini" ''
    [master-public-keys]
    ${foldAttrToIni masterPublicKeys}

    [bitcoin-rpc]
    host = 127.0.0.1
    port = ${bitcoinRpcPort}
    rpc_user = ${bitcoinRpcUser}
    rpc_password = ${bitcoinRpcPassword}
    wallet_filename = ${bitcoinRpcWallet}
    poll_interval_listening = 30
    poll_interval_connected = 1
    initial_import_count = 1000
    gap_limit = 25

    [electrum-server]
    host = 127.0.0.1
    port = 50002
    ip_whitelist = *
    certfile = certs/cert.crt
    keyfile = certs/cert.key
    disable_mempool_fee_histogram = false
    broadcast_method = tor-or-own-node

    [watch-only-addresses]
    ${foldAttrToIni watchOnlyAddresses}

    [logging]
    log_level_stdout = INFO
    log_file_location =
    append_log = false
    log_format = %(levelname)s:%(asctime)s: %(message)s
  '';
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

    postInstall = ''
      cp ${configFile} $out/config.ini
    '';

    makeWrapperArgs = ["--add-flags" "$out/config.ini"];

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
