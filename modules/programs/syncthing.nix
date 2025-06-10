{
  pkgs,
  lib,
  config,
  ...
}: {
  # Allow module to be easily enabled and disabled
  options = {
    syncthing.enable =
      lib.mkEnableOption "enables syncthing";
  };

  config = lib.mkIf config.syncthing.enable {
    # Enable syncthing
    services.syncthing = {
      enable = true;
      user = "dyllant";
      dataDir = "/home/dyllant/";
      configDir = "/home/dyllant/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "Desktop" = {id = "A5Z5KDG-SOBDA2J-7D73STH-WLGTXE3-GMEUGZG-5UJZVZY-JDJAE4H-CVGPEAI";};
          "Laptop" = {id = "R6E4T4B-CLTDEN2-R4ZGDJC-3ZN7SP5-T52ZZEQ-65GFTYK-ZFF7DRC-L6ZFTA6";};
        };
        folders = {
          "Documents" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/dyllant/Documents"; # Which folder to add to Syncthing
            devices = ["Desktop" "Laptop"]; # Which devices to share the folder with
            ignorePerms = false; # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
          };
          "Downloads" = {
            path = "/home/dyllant/Downloads";
            devices = ["Desktop" "Laptop"];
            ignorePerms = false;
          };
          "Music" = {
            path = "/home/dyllant/Music";
            devices = ["Desktop" "Laptop"];
            ignorePerms = false;
          };
          "Pictures" = {
            path = "/home/dyllant/Pictures";
            devices = ["Desktop" "Laptop"];
            ignorePerms = false;
          };
          "Public" = {
            path = "/home/dyllant/Public";
            devices = ["Desktop" "Laptop"];
            ignorePerms = false;
          };
          "Templates" = {
            path = "/home/dyllant/Templates";
            devices = ["Desktop" "Laptop"];
            ignorePerms = false;
          };
          "Videos" = {
            path = "/home/dyllant/Videos";
            devices = ["Desktop" "Laptop"];
            ignorePerms = false;
          };
        };
      };
    };
  };
}
