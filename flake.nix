{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nvidia-patch = {
        url = "github:icewind1991/nvidia-patch-nixos";  
        inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      # TODO please change the hostname to your own
      Dyllans-Desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.dyllant = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
          ({ config, pkgs, ... }: 
            let
              # nvidia package to patch
              package = config.boot.kernelPackages.nvidiaPackages.stable;
            in
            { 
              # Load nvidia driver for Xorg and Wayland
              services.xserver.videoDrivers = ["nvidia"];

              nixpkgs.overlays = [inputs.nvidia-patch.overlays.default];
              # Enable nvidia driver
              hardware.nvidia = {

                # Modesetting is required.
                modesetting.enable = true;

                # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
                # Enable this if you have graphical corruption issues or application crashes after waking
                # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
                # of just the bare essentials.
                powerManagement.enable = false;

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

                # Optionally, you may need to select the appropriate driver version for your specific GPU.
                package = pkgs.nvidia-patch.patch-nvenc (pkgs.nvidia-patch.patch-fbc package);
              };

              environment.systemPackages = with pkgs; [
                nvidia-vaapi-driver
                nvidia-podman
              ];
            })
          ./configuration.nix          
        ];
      };
    };
  };
}