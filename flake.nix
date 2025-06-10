{
  description = "NixOS configuration of Dyllan Tinoco";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    disko,
    nixos-facter-modules,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};
    nixosConfigurations = {
      Dyllans-Desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;

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
            home-manager.users.dyllant = import ./home/dyllant;
          }
        ];
      };

      TestVM = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/TestVM];
      };

      homeConfigurations = {
        "dyllant@TestVM" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [./home/dyllant];
        };
      };
    };
  };
}
