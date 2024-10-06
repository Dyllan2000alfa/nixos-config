{ pkgs, lib, config, ... }:

{

  # Import all submodules
  imports = [
    ./amd.nix
    ./intel.nix
    ./nvidia.nix
  ];

  # Set sub modules to off by default
  amd.enable =
    lib.mkDefault false;

  intel.enable =
    lib.mkDefault false;
  
  nvidia.enable =
    lib.mkDefault false;
}