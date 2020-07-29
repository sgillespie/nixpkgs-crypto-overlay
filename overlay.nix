self: super:

let
  inherit (super) callPackage config lib;
in
{
  electrumPersonalServer = callPackage ./pkgs/electrum-personal-server.nix { };
  ethminer_rocm = callPackage ./pkgs/ethminer.nix { };
}
