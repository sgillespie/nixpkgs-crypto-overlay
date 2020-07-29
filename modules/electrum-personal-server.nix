{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  inherit (pkgs) buildEnv writeTextDir;
  cfg = config.services.electrumPersonalServer;

  foldAttrToIni = attr: pipe attr [
    (a: mapAttrsToList (k: v: "${k} = ${v}") a)
    (a: concatStringsSep "\n" a)
  ];
  
  serverConfig = ''
    [master-public-keys]
    ${foldAttrToIni cfg.masterPublicKeys}

    [bitcoin-rpc]
    host = 127.0.0.1
    ${optionalString (cfg.bitcoinRpc.port != null)
      "port = ${toString cfg.bitcoinRpc.port}"
    }
    ${optionalString (cfg.bitcoinRpc.user != null)
      "rpc_user = ${cfg.bitcoinRpc.user}"
    }
    ${optionalString (cfg.bitcoinRpc.password != null)
      "rpc_password = ${cfg.bitcoinRpc.password}"
    }
    ${optionalString (cfg.bitcoinRpc.wallet != null)
      "wallet_filename = ${cfg.bitcoinRpc.wallet}"
    }
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
    ${foldAttrToIni cfg.watchOnlyAddresses}

    [logging]
    log_level_stdout = INFO
    log_file_location =
    append_log = false
    log_format = %(levelname)s:%(asctime)s: %(message)s
  '';

  configDir = buildEnv {
    name = "electrum-personal-server-config";
    paths = [
      (writeTextDir "config.ini" serverConfig)
    ];
  };

in

{
  imports = [];
  
  options = {
    services.electrumPersonalServer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable Electron Personal Server.";
      };

      masterPublicKeys = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = "Master public keys to track.";
      };

      watchOnlyAddresses = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = "Watch-only addresses to track.";
      };

      bitcoinRpc = {
        port = mkOption {
          type = with types; nullOr port;
          default = 8334;
          description = "Bitcoin RPC port.";
        };

        user = mkOption {
          type = with types; nullOr str;
          description = "Bitcoin RPC user.";
        };

        password = mkOption {
          type = with types; nullOr str;
          description = "Bitcoin RPC password.";
        };

        wallet = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "Bitcoin wallet address";
        };
      };
    };
  };

  config = {
    systemd.services.electrum-personal-server = mkIf cfg.enable {
      description = "Electrum Personal Server";

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
      };

      script = ''
        ${pkgs.electrumPersonalServer}/bin/electrum-personal-server ${configDir}/config.ini
      '';
    };
  };
}
