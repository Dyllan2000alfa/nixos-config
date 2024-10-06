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
    ./virtual-machines.nix
    ./system.nix
  ];

  # Set sub modules to off by default
  podman.containers.enable =
    lib.mkDefault false;

  flatpaks.enable =
    lib.mkDefault false;
  
  gaming.enable =
    lib.mkDefault false;
  
  audio.enable = 
    lib.mkDefault false;

  samba.enable = 
    lib.mkDefault false;
  
  vms.enable =
    lib.mkDefault false;
}