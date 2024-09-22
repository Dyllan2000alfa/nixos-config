{ lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./git.nix
    ../../../../modules/home-manager/browsers/librewolf.nix
    ../../../../modules/home-manager/programs/codium.nix
    ../../../../modules/home-manager/programs/obs.nix
  ];
}