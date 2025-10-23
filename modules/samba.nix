{
  lib,
  config,
  ...
}: {
  # Allow module to be easily enabled and disabled
  options = {
    samba.enable =
      lib.mkEnableOption "enables samba";
  };

  config = lib.mkIf config.samba.enable {
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "isos" = {
          "path" = "/mnt/isos";
          "browsable" = "yes";
          "writable" = "no";
          "guest ok" = "yes";
          "read only" = "yes";
        };
        "media" = {
          "path" = "/mnt/media";
          "browsable" = "yes";
          "writable" = "no";
          "guest ok" = "yes";
          "read only" = "yes";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}
