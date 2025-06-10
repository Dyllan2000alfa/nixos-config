{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./configuration.nix
    ../../modules
    inputs.vgpu4nixos.nixosModules.host

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  graphics.nvidia.enable = false;
  graphics.nvidia-vgpu.enable = false;
  audio.enable = false;
  kde.enable = false;
  hyprland.enable = false;
  gaming.enable = false;
  flatpaks.enable = false;
  podman.containers.enable = false;
  vms.enable = false;
  sunshine.enable = false;
  ckb-next.enable = false;
  ssh.enable = false;
  syncthing.enable = false;
  webdav-server.enable = false;
}