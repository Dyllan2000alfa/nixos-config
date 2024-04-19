{ config, pkgs, ... }:

{
  # Enable KVM virtual machines
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}