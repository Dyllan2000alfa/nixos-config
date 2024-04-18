{ pkgs, ... }:

{
  services.xserver = {
    
    # Enable X Server
    enable = true;

    #Set sddm as the displayManager
    displayManager.sddm.enable = true;

    #Enable plasma5
    desktopManager.plasma5.enable = true;
  };
}