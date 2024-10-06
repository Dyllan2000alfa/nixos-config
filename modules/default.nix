{ pkgs, lib, config, ... }:

{

  # Import all submodules
  imports = [
    ./display-managers
    ./graphics
    ./containers.nix
    ./flatpak.nix
    ./gaming.nix
    ./pipewire.nix
    ./samba.nix
    ./system.nix
    ./virtual-machines.nix
  ];
}