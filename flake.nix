{
  description = "NixOS configuration of Dyllan Tinoco";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nvidia-patch = {
        url = "github:icewind1991/nvidia-patch-nixos";  
        inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, flatpaks, ... }: 
  {
    nixosConfigurations = {
      Dyllans-Desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Dyllans-Desktop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs.flake-inputs = inputs;
            home-manager.users.dyllant = import ./home;
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
            home-manager.users.dyllant = import ./home;
          }
        ];
      };
    };
  };
}