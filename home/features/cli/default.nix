{
  pkgs,
  ...
}: {

  imports = [
    ./fish.nix
  ];

  programs = {
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    bat = {enable = true;};
  };

  home.packages = with pkgs; [
    coreutils
    fd
    htop
    httpie
    procs
    ripgrep
    tldr
    zip
  ];
}