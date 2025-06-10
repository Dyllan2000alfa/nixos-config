{
  description = "NixOS configuration of Dyllan Tinoco";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nix-gaming.url = "github:fufexan/nix-gaming";

    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    vgpu4nixos.url = "github:mrzenc/vgpu4nixos";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvidia-patch = {
        url = "github:icewind1991/nvidia-patch-nixos/";  
        inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      
    };
  };

  outputs = {
    nixpkgs,
    disko,
    nixos-facter-modules,
    home-manager,
    flatpaks,
    nixpkgs-unstable,
    vgpu4nixos,
    ...
  }@inputs:
   
  {
    nixosConfigurations = {
      Dyllans-Desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { 
          inherit inputs;
          
          unstable = import nixpkgs-unstable {
            config.allowUnfree = true;
            system = "x86_64-linux";
          };
        };

        modules = [
          ./hosts/Dyllans-Desktop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	          home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs.inputs = inputs;
            home-manager.extraSpecialArgs = {
              unstable = import nixpkgs-unstable {
                config.allowUnfree = true;
                system = "x86_64-linux";
              };
            };
            home-manager.users.dyllant = import ./home/dyllant;
          }
        ];
      };
    };
  };
}
