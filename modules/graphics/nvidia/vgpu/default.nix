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
      useMyDriver = {
        enable = true;
        name = "NVIDIA-Linux-x86_64-535.129.03-merged-vgpu-kvm-patched.run";
        sha256 = "sha256-Us69ZyJi/Co4iwEm64vFVYgLgVSNaac5ww/YvPxcoqM=";
        driver-version = "535.129.03";
        vgpu-driver-version = "535.129.03";
        # you can not specify getFromRemote and it will ask to add the file manually with `nix-store --add-fixed...`
        getFromRemote = pkgs.fetchurl {
          name = "NVIDIA-Linux-x86_64-535.129.03-merged-vgpu-kvm-patched.run"; # So there can be special characters in the link below: https://github.com/NixOS/nixpkgs/issues/6165#issuecomment-141536009
          url = "https://drive.usercontent.google.com/download?id=17NN0zZcoj-uY2BELxY2YqGvf6KtZNXhG&export=download&authuser=0&confirm=t&uuid=b70e0e36-34df-4fde-a86b-4d41d21ce483&at=APZUnTUfGnSmFiqhIsCNKQjPLEk3%3A1714043345939";
          sha256 = "sha256-Us69ZyJi/Co4iwEm64vFVYgLgVSNaac5ww/YvPxcoqM=";
        };
      };
      fastapi-dls = { # License server for unrestricted use of the vgpu driver in guests
        enable = true;
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
}
