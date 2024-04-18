{
  description = "NixOS configuration of Dyllan Tinoco";

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

  outputs = inputs@{ nixpkgs, home-manager, ... }: 
  {
    nixosConfigurations = {
      Dyllans-Desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/dyllans-Desktop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs;
            home-manager.users.ryan = import ./home;
          }
        ];
      };

      Dyllans-Laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/Dyllans-Laptop

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs;
            home-manager.users.ryan = import ./home;
          }
        ];
      };
    };
  };
}