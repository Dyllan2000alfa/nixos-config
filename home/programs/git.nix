{ pkgs, ... }:

{
  #Install github cli tool
  home.packages = [ pkgs.gh ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Dyllan Tinoco";
    userEmail = "dyllan@tinoco.casa";
  };
}