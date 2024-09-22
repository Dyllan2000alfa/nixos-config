{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    waybar
    hyprpaper
    hyprlock
    polkit-kde-agent
    xdg-desktop-portal-gtk
    qt5-wayland
    qt6-wayland
  ];
}