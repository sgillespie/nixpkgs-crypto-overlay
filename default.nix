{ config, pkgs, ... }:

let
  nixosRocmGit = fetchGit {
    url = "https://github.com/nixos-rocm/nixos-rocm.git";
  };
in

{
  imports = [
    ./modules
  ];
  
  nixpkgs.overlays = [
    (import nixosRocmGit)
    (import ./overlay.nix)
  ];
}
