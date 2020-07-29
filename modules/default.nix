{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    ./electrum-personal-server.nix
    ./ethminer.nix
    ./xmrig.nix
  ];
}
