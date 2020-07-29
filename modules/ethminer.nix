{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.ethminerRocm;
  poolUrl = escapeShellArg "${cfg.scheme}://${cfg.wallet}@${cfg.pool}:${toString cfg.stratumPort}/${cfg.rig}/${cfg.registerMail}";
in

{
  imports = [];
  options = {
    services.ethminerRocm = {
      apiPort = mkOption {
        type = types.int;
        default = -3333;
        description = "Ethminer api port. minus sign puts api in read-only mode.";
      };
      
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the AMD Ethminer.
        '';
      };

      maxPower = mkOption {
        type = types.ints.positive;
        default = 110;
        description = ''
          Max watt usage.
        '';
      };

      pool = mkOption {
        type = types.str;
        example = "eth-us-east1.nanopool.org";
        description = ''
          Mining pool address.
        '';
      };

      recheckInterval = mkOption {
        type = types.int;
        default = 2000;
        description = "Interval in milliseconds between farm rechecks.";
      };      
      
      registerMail = mkOption {
        type = types.str;
        example = "email%40example.org";
        description = ''
          Url encoded email address to register with pool.
        '';
      };

      rig = mkOption {
        type = types.str;
        default = "mining-rig-name";
        description = ''
          Mining rig name.
        '';
      };

      scheme = mkOption {
        type = types.str;
        default = "stratum1+tcp";
        description = ''
          Mining protocol scheme.
        '';
      };

      stratumPort = mkOption {
        type = types.port;
        default = 9999;
        description = ''
          Stratum protocol tcp port.
        '';
      };

      wallet = mkOption {
        type = types.str;
        example = "0x0123456789abcdef0123456789abcdef01234567";
        description = ''
          Ethereum mining address.
        '';
      };
    };
  };

  config = {
    systemd.services.ethminer-rocm = mkIf config.services.ethminerRocm.enable {
      description = "ethminer ethereum mining service";

      serviceConfig = {
        DynamicUser = true;
        ExecStartPre = "${pkgs.ethminer_rocm}/bin/.ethminer-wrapped --list-devices";
        Restart = "always";
      };

      script = ''
        ${pkgs.ethminer_rocm}/bin/.ethminer-wrapped \
          --farm-recheck ${toString cfg.recheckInterval} \
          --report-hashrate \
          --opencl \
          --api-port ${toString cfg.apiPort} \
          --pool ${poolUrl}
      '';
    };

  };
}
