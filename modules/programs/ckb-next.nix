{
  pkgs,
  lib,
  config,
  ...
}: {
  # Allow module to be easily enabled and disabled
  options = {
    ckb-next.enable =
      lib.mkEnableOption "enables ckb-next";
  };

  config = lib.mkIf config.ckb-next.enable {
    hardware.ckb-next = {
      enable = true; # enable ckb-next daemon
      package = pkgs.ckb-next.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DUSE_DBUS_MENU=0" ];
      });
    };
    hardware.i2c.enable = true; # Enable i2c
  };
}
