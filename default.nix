self: super:

let
  inherit (super) callPackage config lib;
in
{
  electrumPersonalServer = callPackage ./pkgs/electrum-personal-server.nix {
    inherit (config.electrumPersonalServer)
      masterPublicKeys
      watchOnlyAddresses;
    
    bitcoinRpcPort = config.electrumPersonalServer.bitcoind.port;
    bitcoinRpcUser = config.electrumPersonalServer.bitcoind.rpcUser;
    bitcoinRpcPassword = config.electrumPersonalServer.bitcoind.rpcPassword;
    bitcoinRpcWallet = config.electrumPersonalServer.bitcoind.walletFilename;
  };
  
  ethminer_rocm = callPackage ./pkgs/ethminer.nix {
    inherit (config.ethminer) pool;
  };
  
  xmrig = callPackage ./pkgs/xmrig.nix {
    inherit (config.xmrig) algorithm tls url user;
  };
}
