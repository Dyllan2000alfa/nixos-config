{ config, pkgs, inputs, ... }:
{

    wayland.windowManager.hyprland.package = true;

  # Packages need for hypland
  home.packages = with pkgs; [
    waybar
    hyprpaper
    hyprlock
    polkit-kde-agent
    xdg-desktop-portal-gtk
    qt5-wayland
    qt6-wayland
    mako
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1, 1440x900@75, 0x0, 1"
      "DP-2, 1920x1080@75, 1440x0,1"
      "DP-3, 1600x900@60, 1680x-1080, 1"
    ];
  };
}