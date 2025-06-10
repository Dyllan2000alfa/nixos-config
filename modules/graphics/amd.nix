{
  pkgs,
  lib,
  config,
  ...
}: {
  # Allow module to be easily enabled and disabled
  options = {
    graphics.amd.enable =
      lib.mkEnableOption "enables amd graphics";
  };

  config = lib.mkIf config.graphics.amd.enable {
    # Enable opengl
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
        libva-mesa-driver
        mesa-vdpau
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-vaapi-driver
        amdvlk
      ];
    };

    # Make the kernel use the correct driver
    boot.initrd.kernelModules = ["amdgpu"];

    # Set radeonsi as libva driver
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "radeonsi";};

    # Load amd driver for Xorg and Wayland
    services.xserver.videoDrivers = [" amdgpu "];
  };
}
