{config, ...}: {
  imports = [
    ./home.nix 
    ../common 
    ../../modules/home-manager/hyprland.nix
  ];

  features = {
    cli = {
      fish.enable = true;
    };
  };
}
