{ config, pkgs, inputs, ... }:

{
  imports = [ (fetchTarball {
  url = "https://github.com/Dyllan2000alfa/nixos-nvidia-vgpu/archive/master.tar.gz";
  sha256 = "1br64amwf29yrnfchkgj6qy4gv490ls3kx3hrvdpiq8asklw0y9a";
}) ];

  # Enable opengl
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Set nvidia as libva driver
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "nvidia"; };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  #Enable nvidia driver
  hardware.nvidia = {
    vgpu = {
      enable = true; # Install NVIDIA KVM vGPU + GRID merged driver for consumer cards with vgpu unlocked.
      unlock.enable = true; # Activates systemd services to enable vGPU functionality on using DualCoder/vgpu_unlock project.
    };

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;
  };
}