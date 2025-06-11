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
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  graphics.nvidia.enable = false;
  graphics.nvidia-vgpu.enable = false;
  audio.enable = true;
  kde.enable = false;
  hyprland.enable = true;
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
