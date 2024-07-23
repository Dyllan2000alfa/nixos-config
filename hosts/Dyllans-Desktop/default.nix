# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/system.nix
      ../../modules/kde.nix
      ../../modules/pipewire.nix
      ../../modules/graphics/nvidia.nix
      ../../modules/gaming.nix
      ../../modules/flatpak.nix
      ../../modules/containers.nix
      ../../modules/virtualization.nix
      ../../modules/samba.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = true;
  };

  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];

  hardware.i2c.enable = true;

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
  hardware.ckb-next.enable = true; # enable ckb-next daemon

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
