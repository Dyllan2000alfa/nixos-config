{ config, pkgs, ... }:

{
 programs = {
    #Enable firefox
    firefox = {
      enable = true;
    };
  };
}