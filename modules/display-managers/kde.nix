{
  pkgs,
  lib,
  config,
  ...
}: {
  # Allow module to be easily enabled and disabled
  options = {
    kde.enable =
      lib.mkEnableOption "enables kde";
  };

  config = lib.mkIf config.kde.enable {
    services = {
      xserver = {
        # Enable X Server
        enable = true;
      };

      #Set sddm as the displayManager
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      #Enable plasma6
      desktopManager.plasma6.enable = true;

      # Enable avahi
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };

    # Enable KDE Connect
    programs.kdeconnect.enable = true;

    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };

    environment.systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.polkit-kde-agent-1
      kdePackages.powerdevil
    ];
  };
}
