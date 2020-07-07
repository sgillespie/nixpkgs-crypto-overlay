{
  pkgPath ? <nixpkgs>
}:

let
  overlay = import ./default.nix;
  pkgs = import pkgPath { overlays = [overlay]; };
  inherit (pkgs) mkShell;
in
  mkShell {
    buildInputs = with pkgs; [
      xmrig
    ];
  }
