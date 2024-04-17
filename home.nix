{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "dyllant";
  home.homeDirectory = "/home/dyllant";

  programs.bash.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    tree
    ckb-next
    sunshine
    spotify
    atool
    httpie
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      bbenoist.nix
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-tuna
      obs-nvfbc
      looking-glass-obs
      input-overlay
      droidcam-obs
    ];
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Dyllan Tinoco";
    userEmail = "dyllan@tinoco.casa";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}