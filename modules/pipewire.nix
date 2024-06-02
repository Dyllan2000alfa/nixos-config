{ pkgs, ... }:
{
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  services = {
  # Enable pipewire audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    rnnoise-plugin
  ];
}