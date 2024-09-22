{ config, pkgs, inputs, ... }:

{
  imports = [
    ./programs
    ./shell
    ../../../modules/home-manager/hyprland.nix
    inputs.flatpaks.homeManagerModules.nix-flatpak
  ];

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "daily"; # Default value
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "dyllant";
    homeDirectory = "/home/dyllant";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}