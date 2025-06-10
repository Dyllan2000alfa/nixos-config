{
  pkgs,
  lib,
  config,
  ...
}: {
  # Allow module to be easily enabled and disabled
  options = {
    graphics.intel.enable =
      lib.mkEnableOption "enables intel graphics";
  };

  config = lib.mkIf config.graphics.intel.enable {
    # Enable opengl
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-vaapi-driver
      ];
    };

    # Set intel as libva driver
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
  };
}
