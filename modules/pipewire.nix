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

  services.pipewire.extraConfig.pipewire."99-input-denoising" = {
    context.modules = [
      {
        name = libpipewire-module-filter-chain;
        args = {
          node.description =  "Noise Canceling source";
          media.name =  "Noise Canceling source";
          filter.graph = {
            nodes = [
              {
                type = ladspa;
                name = rnnoise;
                plugin = /run/current-system/sw/lib/ladspa/librnnoise_ladspa.so
                label = noise_suppressor_mono;
                control = {
                  "VAD Threshold (%)" = 50.0;
                  "VAD Grace Period (ms)" = 200;
                  "Retroactive VAD Grace (ms)" = 0;
                };
              }
            ]
          };
          capture.props = {
            node.name =  "capture.rnnoise_source";
            node.passive = true;
            audio.rate = 48000;
          };
          playback.props = {
            node.name =  "rnnoise_source";
            media.class = Audio/Source;
            audio.rate = 48000;
          };
        };
      }
    ]
  };
}