{
  description = "NixOS configuration of Dyllan Tinoco";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 
    nix-gaming.url = "github:fufexan/nix-gaming";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nixos-nvidia-vgpu.url = "github:Yeshey/nixos-nvidia-vgpu/535.129";
    nvidia-patch = {
        url = "github:icewind1991/nvidia-patch-nixos/";  
        inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    flatpaks,
    nixpkgs-unstable,
    ...
  }: {
    nixosConfigurations = {
      Dyllans-Desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { 
          inherit inputs;

          pkgs-unstable = import nixpkgs-unstable {
            config.allowUnfree = true;
          };
        };

        modules = [
          ./hosts/Dyllans-Desktop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    home-manager.backupFileExtension = "backup";

            home-manager.extraSpecialArgs.flake-inputs = inputs;
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
