{
  lib,
  config,
  ...
}: {
  # Allow module to be easily enabled and disabled
  options = {
    ssh.enable =
      lib.mkEnableOption "enables ssh server";
  };

  config = lib.mkIf config.ssh.enable {
    services = {
      # Enable the OpenSSH daemon.
      openssh = {
        enable = true;
        settings = {
          X11Forwarding = true;
          PermitRootLogin = "no"; # disable root login
          PasswordAuthentication = false; # disable password login
        };
        openFirewall = true;
      };
    };
  };
}
