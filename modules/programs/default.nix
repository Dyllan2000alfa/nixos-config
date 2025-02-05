{ pkgs, lib, config, ... }:

{

  # Import all submodules
  imports = [
    ./ckb-next.nix
    ./sunshine.nix
    ./ssh.nix
    ./syncthing.nix
    ./webdav-server.nix
  ];

  # Set sub modules to off by default
  ckb-next.enable =
    lib.mkDefault false;

  sunshine.enable = 
    lib.mkDefault false;

  ssh.enable = 
    lib.mkDefault false;

  syncthing.enable = 
    lib.mkDefault false;
  
  webdav-server.enable = 
    lib.mkDefault false;
}