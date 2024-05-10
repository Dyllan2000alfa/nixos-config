{
  description = "NixOS configuration of Dyllan Tinoco";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    nixos-nvidia-vgpu = {
      url = "github:Yeshey/nixos-nvidia-vgpu/535.129";
      # inputs.nixpkgs.follows = "nixpkgs"; # doesn't work with latest nixpkgs rn
    };
    nvidia-patch = {
        url = "github:icewind1991/nvidia-patch-nixos/";  
        inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = 
  {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flatpaks,
    nixos-nvidia-vgpu,
    ...
  }
  
  @inputs: 
  {
    nixosConfigurations = {
      Dyllans-Desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = 
        { inherit inputs; };
        modules = [
          ./hosts/Dyllans-Desktop

          nixos-nvidia-vgpu.nixosModules.nvidia-vgpu
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

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