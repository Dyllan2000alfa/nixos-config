{ config, pkgs, inputs, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &

    # Start waybar
    ${pkgs.waybar}/bin/waybar &
    
    # Start mako
    ${pkgs.mako}/bin/mako
  '';
in
{

  wayland.windowManager.hyprland = {
    
    # Enable hyprland
    enable = true;

    # Add plugins
    plugins = [ 
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];

    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;

    # Hyprland settings
    settings = {
      
      # Run start up script
      exec-once = ''${startupScript}/bin/start'';

      # Configure monitors
      monitor = [
        "DP-1, 1440x900@60, 0x1080, 1"
        "DP-2, 1920x1080@75, 1440x900,1"
        "DP-3, 1600x900@60, 1680x0, 1"
      ];

      # Configure keybinds
      bind = [
        # Terminal
        "CONTROL_ALT, T, exec, kitty"

        # Rofi
        "SUPER, r, exec, rofi -show drun -show-icons"

        # Logout
        "SUPER, l, exec, hyprctl dispatch exit"
      ];
    };
  };

  # Packages need for hypland
  home.packages = with pkgs; [
    waybar
    mpvpaper
    polkit-kde-agent
    mako
    libnotify
    kitty
    rofi-wayland
    networkmanagerapplet
  ];
}
