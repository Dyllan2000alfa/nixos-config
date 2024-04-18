{ config, pkgs, ... }:

{
  # Give flatpak ccess to theme and fonts dir
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [
        libsForQt5.breeze-qt5  # for plasma
        tela-icon-theme
      ];
      pathsToLink = [ "/share/icons" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
    aggregatedThemes = pkgs.buildEnv {
      name = "system-themes";
      paths = with pkgs; [
        layan-gtk-theme
      ];
      pathsToLink = [ "/share/themes" ];
    };
  in {
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    "/usr/share/themes" = mkRoSymBind "${aggregatedThemes}/share/themes";
  };

  
}