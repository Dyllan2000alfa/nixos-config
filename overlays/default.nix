# ./overlays/default.nix
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [inputs.nvidia-patch.overlays.default];
}