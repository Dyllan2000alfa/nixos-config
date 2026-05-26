{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = ["zfs.zfs_arc_max=2147483648" "nvidia_drm.fbdev=1" "amd_iommu=on"];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
  ];
  
  boot.zfs.extraPools = [ "Server" ];
  boot.zfs.forceImportRoot = false;

  boot.extraModprobeConfig = ''
    # Keep Bluetooth coexistence disabled for better BT audio stability
    options iwlwifi bt_coex_active=0

    # Enable software crypto (helps BT coexistence sometimes)
    options iwlwifi swcrypto=1

    # Disable power saving on Wi-Fi module to reduce radio state changes that might disrupt BT
    options iwlwifi power_save=0

    # Disable Unscheduled Automatic Power Save Delivery (U-APSD) to improve BT audio stability
    options iwlwifi uapsd_disable=1

    # Disable D0i3 power state to avoid problematic power transitions
    options iwlwifi d0i3_disable=1

    # Set power scheme for performance (iwlmvm)
    options iwlmvm power_scheme=1
  '';

  networking.hostName = "Dyllans-Desktop"; # Define your hostname.
  networking.hostId = "abcd1234"; # Define your hostid for zfs.

  # Enable networking
  networking.networkmanager.enable = true;

  networking.extraHosts = ''
    127.0.0.1 games.tinoco.casa      # Example
    127.0.0.1 pihole     # Example
    
    ....

    '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";
  networking.timeServers = ["time.cloudflare.com"];

  # Make time compatible with windows
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # Normal fonts
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      corefonts
      vista-fonts
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  services = {
    zfs = {
      #Enable zfs scrubbing and trim
      autoScrub.enable = true;
      trim.enable = true;
    };
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      allowSFTP = true;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    ratbagd.enable = false;
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8080 8096 53 80 443 8083 7200];
    allowedUDPPorts = [];
    allowedUDPPortRanges = [];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
