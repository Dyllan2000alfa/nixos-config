{ pkgs, lib, config, ... }:

{
  # Allow module to be easily enabled and disabled
  options = {
    podman.containers.enable =
      lib.mkEnableOption "enables containers";
  };

  config = lib.mkIf config.podman.containers.enable {

    # Enable common container config files in /etc/containers
    virtualisation = {
      containers.enable = true;

      containers.storage.settings = {
        #cdi.dynamic.nvidia.enable = lib.mkIf (config.hardware.nvidia.modesetting.enable) true;

        storage = {
          driver = "zfs";
          runroot = "/run/containers/storage";
          graphroot = "/var/lib/containers/storage";
          rootless_storage_path = "/tmp/containers-$USER";
        };
      };

      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
      
        dockerSocket.enable = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;

        extraPackages = [ pkgs.zfs ]; # Required if the host is running ZFS
      };
    };

    environment.systemPackages = with pkgs; [ 
      docker-compose
      podman-compose 
    ];
  };
}