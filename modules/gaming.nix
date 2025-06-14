{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  # Allow module to be easily enabled and disabled
  options = {
    gaming.enable =
      lib.mkEnableOption "enables gaming";
  };

  config = lib.mkIf config.gaming.enable {
    #Allow steam to install unfree packages
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
      ];

    # Install steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      platformOptimizations.enable = true;
    };

    #Install gamemode
    programs.gamemode.enable = true;

    environment.systemPackages = [
      inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
    ];
  };
}
