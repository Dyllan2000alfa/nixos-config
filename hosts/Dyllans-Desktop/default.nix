# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, config, ... }:

{
  imports = [
    ../../modules

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  graphics.nvidia.enable = true;
  audio.enable = true;
  kde.enable = true;
  hyprland.enable = true;
  gaming.enable = true;
  flatpaks.enable = true;
  podman.containers.enable = true;
  vms.enable = true;
  sunshine.enable = true;
  ckb-next.enable = true;
  ssh.enable = true;
  syncthing.enable = true;

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = true;
  };

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  #boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" "nvidia_drm.fbdev=1" ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback.out
  ];

  networking.hostId = "abcd1234";
  networking.hostName = "Dyllans-Desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
