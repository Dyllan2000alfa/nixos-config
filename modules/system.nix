{ pkgs, lib, ... }:

{
  # ============================= User related =============================

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dyllant = {
    isNormalUser = true;
    description = "Dyllan Tinoco";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvfEm6EHx5a5J+WMxIpqaWYnqBDwXukKSwUmocfiYgg dyllant@Dyllans-Desktop"
    ];
  };

  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Configure fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # Normal fonts
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      corefonts
      vistafonts
    ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 57621 ];
  # networking.firewall.allowedUDPPorts = [  ];
  
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;

  # Configure services
  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no"; # disable root login
        PasswordAuthentication = false; # disable password login
      };
      openFirewall = true;
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

    # Enable flatpak apps
    flatpak.enable = true;

    # Enable avahi
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    sysstat
    lm_sensors # for `sensors` command
    neofetch
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    wineWowPackages.stable
    winetricks
    dive
    podman-tui
    podman-compose
    rnnoise-plugin
    powerdevil
    ffmpeg-full
    layan-kde
    tela-icon-theme
    layan-gtk-theme
  ];
}