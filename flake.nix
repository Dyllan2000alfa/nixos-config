{
  description = "NixOS configuration of Dyllan Tinoco";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 

    nix-gaming.url = "github:fufexan/nix-gaming";

    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    vgpu4nixos.url = "github:mrzenc/vgpu4nixos";

    nvidia-patch = {
        url = "github:icewind1991/nvidia-patch-nixos/";  
        inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      
    };
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    flatpaks,
    nixpkgs-unstable,
    vgpu4nixos,
    ...
  }: 
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

      Dyllans-Laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Dyllans-Laptop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs.flake-inputs = inputs;
            home-manager.users.dyllant = import ./home/dyllant;
          }
        ];
      };
    };
  };
}
