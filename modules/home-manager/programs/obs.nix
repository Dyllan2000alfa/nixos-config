{ lib, pkgs, ... }:

{
  programs.obs-studio = {
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
}