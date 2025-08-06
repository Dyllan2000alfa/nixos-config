{config, ...}: {
  imports = [
    ./home.nix 
    ../common
    ../features/cli
    ../../modules/home-manager/hyprland.nix
  ];

  features = {
    cli = {
      fish.enable = true;
    };
  };
}
