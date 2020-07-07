self: super:

let
  inherit (super) callPackage config;
in
{
  xmrig = callPackage ./pkgs/xmrig.nix {
    inherit (config.xmrig) algorithm tls url user;
  };
}
