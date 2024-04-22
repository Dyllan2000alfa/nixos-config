{ config, pkgs, ... }:

{
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
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Set nvidia as libva driver
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "radeonsi"; };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [" amdgpu "];
}