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
  boot = {

    # Enable systemd boot loader
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };

    # Define service for ephemeral root
    initrd.systemd = {
      enable = true;
      services.initrd-rollback-root = {
        after = [ "zfs-import-rpool.service" ];
        wantedBy = [ "initrd.target" ];
        before = [
          "sysroot.mount"
        ];
        path = [ pkgs.zfs ];
        description = "Rollback root fs";
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = "zfs rollback -r rpool/nixos/empty@start";
      };
    };

    kernelPackages = pkgs.linuxPackages;
    
    zfs.forceImportRoot = false;
  };

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    
    # Define system hostname and id
    hostName = "TestVM";
    hostId = "2a1a97c4";
    
    # Manually set a time server if needed
    #timeServers = ["time.cloudflare.com"];

    #Enable firewall and specify allowed ports
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowedUDPPortRanges = [];
    };
  };

  hardware.bluetooth = {
    enable = false;
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

  time = {
    # Set time zone for system
    timeZone = "America/Chicago";

    # Make system clock compatible with windows for dual booting
    hardwareClockInLocalTime = false;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # List services that you want to enable:

  services = {
    #Enable zfs scrubbing, trim and snapshot if desired
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
      autoSnapshot.enable = true;
    };

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
