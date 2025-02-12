{ pkgs, lib, config, ... }:

{
  # Allow module to be easily enabled and disabled
  options = {
    sunshine.enable =
      lib.mkEnableOption "enables sunshine game streaming";
  };

  config = lib.mkIf config.sunshine.enable {

    environment.systemPackages = with pkgs; [
      cudatoolkit
      cuda_cudart
    ];

    services.sunshine = {
      package = pkgs.sunshine.override { cudaSupport = true; };

      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
