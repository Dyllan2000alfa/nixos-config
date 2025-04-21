{ pkgs, lib, config, ... }:

{

  # Import all submodules
  imports = [
    ./amd.nix
    ./intel.nix
    ./nvidia.nix
    ./nvidia-vgpu.nix
  ];

  # Set sub modules to off by default
  graphics.amd.enable =
    lib.mkDefault false;

  graphics.intel.enable =
    lib.mkDefault false;
  
  graphics.nvidia.enable =
    lib.mkDefault false;

  graphics.nvidia.enable =
    lib.mkDefault false;

}
