{ config, pkgs, inputs, ... }:

{
  programs = {
    #Enable firefox
    firefox = {
      enable = true;
    };
  };

  # Install flatpak librewolf
  services.flatpak.packages = [
    { appId = "io.gitlab.librewolf-community"; origin = "flathub";  }
  ];
}