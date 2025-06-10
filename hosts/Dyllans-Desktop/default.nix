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
    inputs.vgpu4nixos.nixosModules.host

    ../../modules
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  graphics.nvidia.enable = true;
  graphics.nvidia-vgpu.enable = false;
  audio.enable = true;
  kde.enable = true;
  hyprland.enable = false;
  gaming.enable = true;
  flatpaks.enable = true;
  podman.containers.enable = true;
  vms.enable = true;
  sunshine.enable = true;
  ckb-next.enable = true;
  ssh.enable = true;
  syncthing.enable = true;
  webdav-server.enable = false;
}
