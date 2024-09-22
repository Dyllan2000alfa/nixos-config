{ pkgs, ... }:
{
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs [
    kitty # required for the default Hyprland config
  ];

  # Optional, hint electron apps to use wayland:
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
}