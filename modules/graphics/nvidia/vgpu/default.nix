{ config, pkgs, pkgs-unstable, inputs, nixos-nvidia-vgpu, ... }:

{

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

  nixpkgs.overlays = [inputs.nvidia-patch.overlays.default];

  #Enable nvidia driver
  hardware.nvidia = {
    vgpu = {
      enable = true; # Install NVIDIA KVM vGPU + GRID driver + Activates required systemd services
      vgpu_driver_src.sha256 = "sha256-tFgDf7ZSIZRkvImO+9YglrLimGJMZ/fz25gjUT0TfDo="; # use if you're getting the `Unfortunately, we cannot download file...` error # find hash with `nix hash file foo.txt`
      fastapi-dls = { # License server for unrestricted use of the vgpu driver in guests
        enable = true;
        #local_ipv4 = "192.168.1.109"; # Hostname is autodetected, use this setting to override
        #timezone = "Europe/Lisbon"; # detected automatically (needs to be the same as the tz in the VM)
        #docker-directory = "/mnt/dockers"; # default is "/opt/docker"
      };
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

  environment.systemPackages = with pkgs-unstable; [
    pkgs.mdevctl
  ];
}
