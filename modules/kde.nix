{ pkgs, ... }:

{
  services = {
    xserver = {
      # Enable X Server
      enable = true;

      #Set sddm as the displayManager
      displayManager.sddm.enable = true;

      #Enable plasma5
      desktopManager.plasma5.enable = true;
    };

    # Enable pipewire audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable avahi
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };  

  environment.systemPackages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    wineWowPackages.stable
    winetricks
    rnnoise-plugin
    ffmpeg-full
    kate
    kcalc
  ];
}