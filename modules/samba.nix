{ pkgs, lib, config, ... }:

{
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
      extraConfig = ''
        workgroup = WINSHARE
        server string = Samba Server %v
        netbios name = centossrv
        security = user
        map to guest = bad user
        dns proxy = no
        server min protocol = NT1
      '';
      shares = {
        isos = {
          path = "/mnt/isos";
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