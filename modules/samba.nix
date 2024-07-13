{ config, pkgs, lib, ... }:
{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WINSHARE
      server string = Samba Server %v
      netbios name = centossrv
      security = user
      map to guest = bad user
      dns proxy = no
    '';
    shares = {
    share = {
      path = "/home/dyllant/Downloads/";
      "browsable" = "yes";
      "writable" = "no";
      "guest ok" = "yes";
      "read only" = "yes";
    };
  }
}