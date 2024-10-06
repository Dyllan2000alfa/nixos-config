{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # rtkit is optional but recommended
  security.rtkit.enable = true;

  services = {
  # Enable pipewire audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      lowLatency = {
        # enable this module
        enable = true;
        # defaults (no need to be set unless modified)
        quantum = 64;
        rate = 48000;
      };
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

  services.pipewire.extraConfig.pipewire."99-noise-supression" = {
    "context.modules" = [
      {   
        "name" = "libpipewire-module-filter-chain";
        "args" = {
          "node.description" =  "Noise Canceling source";
          "media.name" =  "Noise Canceling source";
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";
                "name" = "rnnoise";
                "plugin" = "/run/current-system/sw/lib/ladspa/librnnoise_ladspa.so";
                "label" = "noise_suppressor_mono";
                "control" = {
                  "VAD Threshold (%)" = 50.0;
                  "VAD Grace Period (ms)" = 200;
                  "Retroactive VAD Grace (ms)" = 0;
                };
              }
            ];
          };
          "capture.props" = {
            "node.name" =  "capture.rnnoise_source";
            "node.passive" = true;
            "audio.rate" = 48000;
          };
          "playback.props" = {
            "node.name" =  "rnnoise_source";
            "media.class" = "Audio/Source";
            "audio.rate" = 48000;
          };
        };
      }
    ];
  };
}