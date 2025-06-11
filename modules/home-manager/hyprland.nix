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

    # Start hyprpaper
    ${pkgs.hyprpaper}/bin/hyprpaper &

    # Start hypridle
    ${pkgs.hypridle}/bin/hypridle &

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

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

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
        "preferred, 1920x1080, 0x0, 1"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = "1";
        sensitivity = "0";
        touchpad = {
          natural_scroll = false;
        };
        numlock_by_default = true;
      };

      # Configure keybinds
      bind = [
        # Terminal
        "CONTROL_ALT, T, exec, kitty -e fish -c 'neofetch: exec fish'"

        # Rofi
        "SUPER, D, exec, wofi --show drun --allow-images"

        # Logout
        "SUPER, l, exec, hyprctl dispatch exit"
      ];

      bindl = [
        # Media controls
        ", XF86AudioNext, exec, playerctl next" # Next
        ", XF86AudioPause, exec, playerctl play-pause" # Pause/Play
        ", XF86AudioPlay, exec, playerctl play-pause" # Pause/Play
        ", XF86AudioPrev, exec, playerctl previous" # previous

        # Volume controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      windowrule = [
        # Example windowrule
        "float,class:^(kitty)$,title:^(kitty)$"
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
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
    hypridle
    playerctl
    nwg-dock-hyprland
    neofetch
    tela-icon-theme
  ];
}
