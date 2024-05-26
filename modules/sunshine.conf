{ config, pkgs, lib, ...}:

let
  cfg = config.services.sunshine;
in

with lib;

{
  options = {
    services.sunshine = {
      enable = mkEnableOption (mdDoc "Sunshine");
    };

  };

  config = mkIf cfg.enable {
    

    environment.systemPackages = with pkgs; [
      unstable.sunshine
    ];

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.unstable.sunshine}/bin/sunshine";
    };

    systemd.user.services.sunshine = {
      description = "Sunshine is a Game stream host for Moonlight.";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = "5";
        ExecStart = "${config.security.wrapperDir}/sunshine";
      };
    };

    services.avahi.publish.userServices = true;

    boot.kernelModules = [ "uinput" ];
    services.udev.extraRules = ''
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    '';

  };
}