{ pkgs, lib, config, inputs, options, unstable, ... }:

{
  # ============================= User related =============================

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dyllant = {
    isNormalUser = true;
    uid = 1000;
    description = "Dyllan Tinoco";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "i2c" "podman" "input" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvfEm6EHx5a5J+WMxIpqaWYnqBDwXukKSwUmocfiYgg dyllant@Dyllans-Desktop"
    ];
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };


  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
    "openssl-1.1.1w"
    ];
  };

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
      noto-fonts-cjk-sans
      corefonts
      vistafonts
    ];
  };

  # Make time compatible with windows
  time.hardwareClockInLocalTime = true;
  networking.timeServers = [ "10.1.0.1" "time.cloudflare.com" ]; 

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 48010 57621 8384 22000 9000 9001 27015 27036 ];
    allowedUDPPorts = [ 22000 21027 27015 ];
    allowedUDPPortRanges = [ 
      { from = 47998; to = 48000; } 
      { from = 8000; to = 8010; }
      { from = 27031; to = 27036; } 
    ];
  };

  # Configure services
  services = {
    zfs = {
      #Enable zfs scrubbing and trim
      autoScrub.enable = true;
      trim.enable = true;
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
    dig
    powerdevil
  ];
}
