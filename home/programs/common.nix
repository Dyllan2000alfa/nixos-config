{ lib, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip
    unrar

    # misc
    ckb-next
    sunshine
    gnome.zenity
    openssl_1_1
  ];

  programs = {
    # Install vscode, my IDE of choice with extensions
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        bbenoist.nix
      ];
    };

    # Install obs-studio with plugins
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-tuna
        obs-nvfbc
        input-overlay
        droidcam-obs
      ];
    };
  };
}