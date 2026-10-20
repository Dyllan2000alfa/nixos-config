# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ../../modules
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  graphics.nvidia.enable = true;
  audio.enable = true;
  kde.enable = true;
  hyprland.enable = false;
  gaming.enable = false;
  flatpaks.enable = false;
  podman.containers.enable = false;
  vms.enable = false;
  sunshine.enable = false;
  ckb-next.enable = false;
  ssh.enable = true;
  syncthing.enable = false;
  webdav-server.enable = false;
  samba.enable = false;
}
