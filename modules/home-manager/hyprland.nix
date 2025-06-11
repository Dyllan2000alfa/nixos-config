{
  config,
  pkgs,
  inputs,
  ...
}: let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &

    # Start waybar
    ${pkgs.waybar}/bin/waybar &

    # Start mako
    ${pkgs.mako}/bin/mako &

    # Start dock
    ${pkgs.nwg-dock-hyprland}/bin/nwg-dock-hyprland -d
  '';
in {
  wayland.windowManager.hyprland = {
    # Enable hyprland
    enable = true;

    # Specify package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    # Add plugins
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    ];

    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;

    # Hyprland settings
    settings = {
      # Run start up script
      exec-once = ''${startupScript}/bin/start'';

      plugin = {
        hyprbars = {
          bar_height = 30;
          bar_color = "rgb(1e1e1e)";
          bar_text_size = 8;
          bar_text_font = "Jetbrains Mono Nerd Font Mono Bold";
          bar_button_padding = 12;
          bar_padding = 10;
          bar_precedence_over_border = true;
          bar_title_enabled = false;

          hyprbars-button = [
            "rgb(ff5d5b), 12, ${pkgs.tela-icon-theme}/share/icons/Tela-purple-dark/24/actions/window-close.svg, hyprctl dispatch killactive"
            "rgb(ffbb39), 12, ${pkgs.tela-icon-theme}/share/icons/Tela-purple-dark/24/actions/window-fullscreen.svg, hyprctl dispatch fullscreen 2"
            "rgb(00cd4e), 12, ${pkgs.tela-icon-theme}/share/icons/Tela-purple-dark/24/actions/window-minimize.svg, hyprctl dispatch togglefloating"
          ];
        };
      };

      # Configure monitors
      monitor = [
        "DP-3, 1440x900@60, 0x1080, 1"
        "DP-2, 1920x1080@75, 1440x900,1"
        "DP-1, 1600x900@60, 1680x0, 1"
      ];

      input = {
        numlock_by_default = true;
      };

      # Configure keybinds
      bind = [
        # Terminal
        "CONTROL_ALT, T, exec, kitty -e fish -c 'neofetch: exec fish'"

        # Rofi
        "SUPER, D, exec, rofi --show drun --allow-images"

        # Logout
        "SUPER, l, exec, hyprctl dispatch exit"

        # Media controls
        ", XF86AudioPlay, exec, playerctl play-pause" # Pause/Play
        ", XF86AudioNext, exec, playerctl next" # Next
        ", XF86AudioPrev, exec, playerctl previous" # previous

        # Volume controls
        ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 1%+"
        ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 1%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "DP-2"
        ];

        modules-left = ["hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["tray" "wireplumber" "cpu"];

        tray = {
          icon-size = 21;
          spacing = 10;
        };
      };
    };
  };

  # Packages need for hypland
  home.packages = with pkgs; [
    kitty
    wofi
    fish
    hyprpaper
    mako
    rofi-wayland
    networkmanagerapplet
    pavucontrol
    nwg-dock-hyprland
  ];
}
