{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.dyllant = {
    isNormalUser = true;
    uid = 1000;
    description = "Dyllan Tinoco";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
      "i2c"
      "podman"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvfEm6EHx5a5J+WMxIpqaWYnqBDwXukKSwUmocfiYgg dyllant@Dyllans-Desktop"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager = {
    useGlobalPkgs = true;
    users.dyllant = import ../../../home/dyllant/${config.networking.hostName}.nix;
  };
}
