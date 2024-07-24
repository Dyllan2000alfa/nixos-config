{ config, pkgs, lib, inputs, ... }:

{
  # ============================= User related =============================

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dyllant = {
    isNormalUser = true;
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
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
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
      noto-fonts-cjk
      #corefonts
      vistafonts
    ];
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 48010 57621 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
    allowedUDPPortRanges = [ 
      { from = 47998; to = 48000; } 
      { from = 8000; to = 8010; } 
    ];
  };

  security.polkit.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';

  # Configure services
  services = {
    zfs = {
      #Enable zfs scrubbing and trim
      autoScrub.enable = true;
      trim.enable = true;
    };
    
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

    # Enable syncthing
    syncthing = {
      enable = true;
      user = "dyllant";
      dataDir = "/home/dyllant/";
      configDir = "/home/dyllant/.config/syncthing";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "Desktop" = { id = "A5Z5KDG-SOBDA2J-7D73STH-WLGTXE3-GMEUGZG-5UJZVZY-JDJAE4H-CVGPEAI"; };
          "Laptop" = { id = "R6E4T4B-CLTDEN2-R4ZGDJC-3ZN7SP5-T52ZZEQ-65GFTYK-ZFF7DRC-L6ZFTA6"; };
        };
        folders = {
          "Documents" = {         # Name of folder in Syncthing, also the folder ID
            path = "/home/dyllant/Documents";    # Which folder to add to Syncthing
            devices = [ "Desktop" "Laptop" ];      # Which devices to share the folder with
            ignorePerms = false;  # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          };
          "Downloads" = {
            path = "/home/dyllant/Downloads";
            devices = [ "Desktop" "Laptop" ];
            ignorePerms = false;
          };
          "Music" = {
            path = "/home/dyllant/Music";
            devices = [ "Desktop" "Laptop" ];
            ignorePerms = false;
          };
          "Pictures" = {
            path = "/home/dyllant/Pictures";
            devices = [ "Desktop" "Laptop" ];
            ignorePerms = false;
          };
          "Public" = {
            path = "/home/dyllant/Public";
            devices = [ "Desktop" "Laptop" ];
            ignorePerms = false;
          };
          "Templates" = {
            path = "/home/dyllant/Templates";
            devices = [ "Desktop" "Laptop" ];
            ignorePerms = false;
          };
          "Videos" = {
            path = "/home/dyllant/Videos";
            devices = [ "Desktop" "Laptop" ];
            ignorePerms = false;
          };
        };
      };
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
    polkit-kde-agent
  ];
}
