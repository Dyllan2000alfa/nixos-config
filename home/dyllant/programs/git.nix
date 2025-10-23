{pkgs, ...}: {
  #Install github cli tool
  home.packages = [pkgs.gh];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings.user = {
      email = "dyllan@tinoco.casa";
      userName = "Dyllan Tinoco";
    };
  };
}
