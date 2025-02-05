{ pkgs, lib, config, ... }:

{
  # Allow module to be easily enabled and disabled
  options = {
    webdav-server.enable =
      lib.mkEnableOption "enables webdav server";
  };

  config = lib.mkIf config.webdav-server.enable {

    networking.firewall = {
      allowedTCPPorts = [ 4918 ];
    };

    services.webdav-server-rs = {
      enable = true;
      configFile = "/home/dyllant/Documents/Phone-Backup/webdav-server.toml";
    };
  };
}