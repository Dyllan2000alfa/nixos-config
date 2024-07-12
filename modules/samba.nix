{ config, pkgs, lib, ... }:
{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    shares = {
      public = {
        path = "/mnt/Shares/Public";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowPing = true;
}