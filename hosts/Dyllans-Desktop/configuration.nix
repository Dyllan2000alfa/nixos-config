{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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
  boot.kernelParams = ["zfs.zfs_arc_max=2147483648" "nvidia_drm.fbdev=1"];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
  ];

  networking.hostName = "Dyllans-Desktop"; # Define your hostname.
   networking.hostId = "abcd1234"; # Define your hostid for zfs.

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Set your time zone.
  time.timeZone = "America/Chicago";
  networking.timeServers = ["10.1.0.1" "time.cloudflare.com"];

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
      noto-fonts-emoji
      noto-fonts-cjk-sans
      corefonts
      vistafonts
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dyllant = {
    isNormalUser = true;
    uid = 1000;
    description = "Dyllan Tinoco";
    extraGroups = ["wheel" "networkmanager" "libvirtd" "i2c" "podman" "input"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvfEm6EHx5a5J+WMxIpqaWYnqBDwXukKSwUmocfiYgg dyllant@Dyllans-Desktop"
    ];
  };

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
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [47984 47989 47990 48010 57621 8384 22000 9000 9001 27015 27036 25565];
    allowedUDPPorts = [22000 21027 27015];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 8000;
        to = 8010;
      }
      {
        from = 27031;
        to = 27036;
      }
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
