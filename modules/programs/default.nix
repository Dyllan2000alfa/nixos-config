{ pkgs, lib, config, ... }:

{

  # Import all submodules
  imports = [
    ./ckb-next.nix
    ./sunshine.nix
    ./ssh.nix
  ];

  # Set sub modules to off by default
  ckb-next.enable =
    lib.mkDefault false;

  sunshine.enable = 
    lib.mkDefault false;

  ssh.enable = 
    lib.mkDefault false;
}