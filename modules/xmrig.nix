{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xmrig;

  xmrConfig = builtins.toJSON {
    pools = [
      {
        algo = cfg.algorithm;
        url = cfg.url;
        user = cfg.user;
        tls = cfg.tls;
      }
    ];
  };

  configDir = pkgs.buildEnv {
    name = "xmr-config";
    paths = [
      (pkgs.writeTextDir "config.json" xmrConfig)
    ];
  };
in

{
  options = {
    services.xmrig = {
      algorithm = mkOption {
        type = types.str;
        default = "rx/0";
        description = "XMRig mining algorithm.";
      };

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable XMRig.";
      };

      tls = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use TLS.";
      };

      url = mkOption {
        type = types.str;
        example = "xmr-us-east1.nanopool.org:14433";
        description = "Mining pool address";
      };

      user = mkOption {
        type = types.str;
        example = "44dZDgJXpRyH6BnLAWEkDq646RjVAheNmD8hb8qEkhjxAFm9NHL7PpMczStYhdQgMZMxdxiF7Yf3jY2x8fWjZKnjRvdTyCR.default/email@email.com";
        description = "Username for mining server";
      };
    };
  };

  config = {
    systemd.services.xmrig = mkIf cfg.enable {
      description = "XMRig mining service";

      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
      };

      script = ''
        ${pkgs.xmrig}/bin/xmrig --config="${configDir}/config.json"
      '';
    };
  };
}
