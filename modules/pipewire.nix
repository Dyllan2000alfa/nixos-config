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

  services.pipewire.extraConfig.pipewire-pulse."40-mix-lfe" = {
    "stream.properties" = {
      "channelmix.upmix"      = true;
      "channelmix.upmix-method" = "psd";
      "channelmix.lfe-cutoff" = 150;
    };
  };

  services.pipewire.extraConfig.client."40-mix-lfe" = {
    "stream.properties" = {
      "channelmix.upmix"      = true;
      "channelmix.upmix-method" = "psd";
      "channelmix.lfe-cutoff" = 150;
    };
  };

  services.pipewire.extraConfig.client-rt."40-mix-lfe" = {
    "stream.properties" = {
      "channelmix.upmix"      = true;
      "channelmix.upmix-method" = "psd";
      "channelmix.lfe-cutoff" = 150;
    };
  };
}