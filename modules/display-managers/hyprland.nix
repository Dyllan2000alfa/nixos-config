{ pkgs, lib, config, inputs, ... }:

{ 

  # Allow module to be easily enabled and disabled
  options = {
    hyprland.enable =
      lib.mkEnableOption "enables hyprland";
  };

  # Main module config
  config = lib.mkIf config.hyprland.enable {

    programs.hyprland = {
      # Enable Hyprland
      enable = true;
    
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      xwayland.enable = true;
    };
  };
}