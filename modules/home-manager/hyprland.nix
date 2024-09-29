{ config, pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    
    # Enable hyprland
    enable = true;

    # Add plugins
    plugins = [ 
      inputs.hy3.packages."${pkgs.system}".hy3 
    ];

    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;

    # Hyprland settings
    settings = {

      # Configure monitors
      monitor = [
        "DP-1, 1440x900@75, 0x0, 1"
        "DP-2, 1920x1080@75, 1440x0,1"
        "DP-3, 1600x900@60, 1680x-1080, 1"
      ];

    };
  };

  # Packages need for hypland
  home.packages = with pkgs; [
    waybar
    hyprpaper
    hyprlock
    polkit-kde-agent
    mako
    kitty
  ];
}