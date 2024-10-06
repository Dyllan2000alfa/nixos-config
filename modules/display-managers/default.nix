{pkgs, lib, config, ...}:

{

  # Import all submodules
  imports = [
    ./hyprland.nix
    ./kde.nix
  ];

  # Set sub modules to off by default
  hyprland.enable =
    lib.mkDefault false;

  kde.enable =
    lib.mkDefault false;
}