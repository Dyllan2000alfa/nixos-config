{ config, pkgs, ... }:

{
  # Install flatpak librewolf
  services.flatpak.packages = [
    { appId = "io.gitlab.librewolf-community"; origin = "flathub";  }
  ];
}